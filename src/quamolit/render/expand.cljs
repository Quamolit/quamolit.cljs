
(ns quamolit.render.expand
  (:require [quamolit.types :refer [Component Shape]]
            [quamolit.util.detect :refer [=seq compare-more]]
            [quamolit.util.list :refer [filter-first]]))

(declare expand-component)

(declare expand-shape)

(declare merge-children)

(defn contain-markups? [items]
  (let [result (some
                (fn [item]
                  (if (or (= Component (type item)) (= Shape (type item)))
                    true
                    (if (and (map? item) (> (count item) 0))
                      (some
                       (fn [child] (or (= Component (type child)) (= Shape (type child))))
                       (vals item))
                      false)))
                items)]
    (comment if (not result) (.log js/console result items))
    result))

(defn merge-children [acc
                      old-children
                      new-children
                      coord
                      states
                      build-mutate
                      at-place?
                      tick
                      elapsed]
  (let [was-empty? (empty? old-children)
        now-empty? (empty? new-children)
        old-cursor (first old-children)
        new-cursor (first new-children)]
    (cond
      (and was-empty? now-empty?) acc
      (and (not was-empty?) (not now-empty?) (= (first old-cursor) (first new-cursor)))
        (recur
         (conj acc [(first new-cursor) (last new-cursor)])
         (rest old-children)
         (rest new-children)
         coord
         states
         build-mutate
         at-place?
         tick
         elapsed)
      (and (not now-empty?)
           (or was-empty? (= 1 (compare-more (first old-cursor) (first new-cursor)))))
        (let [child-key (first new-cursor)
              child (last new-cursor)
              new-acc (conj acc [child-key child])]
          (recur
           new-acc
           old-children
           (rest new-children)
           coord
           states
           build-mutate
           at-place?
           tick
           elapsed))
      (and (not was-empty?)
           (or now-empty? (= -1 (compare-more (first old-cursor) (first new-cursor)))))
        (let [child-key (first old-cursor)
              child (last old-cursor)
              component? (= Component (type child))
              child-coord (conj coord child-key)
              new-acc (if component?
                        (if (:fading? child)
                          (if (let [remove? (:remove? child)] (remove? (:instant child)))
                            acc
                            (conj
                             acc
                             [child-key
                              (expand-component
                               child
                               child
                               child-coord
                               states
                               build-mutate
                               at-place?
                               tick
                               elapsed)]))
                          (let [old-instant (:instant child)
                                on-unmount (:on-unmount child)
                                new-instant (on-unmount old-instant)]
                            (conj
                             acc
                             [child-key (assoc child :instant new-instant :fading? true)])))
                        acc)]
          (recur
           new-acc
           (rest old-children)
           new-children
           coord
           states
           build-mutate
           at-place?
           tick
           elapsed))
      :else acc)))

(defn expand-shape [markup
                    old-tree
                    coord
                    c-coord
                    states
                    build-mutate
                    at-place?
                    tick
                    elapsed]
  (let [old-children (:children old-tree)
        cached-map (into {} old-children)
        new-children (->> (:children markup)
                          (map
                           (fn [child]
                             (let [child-key (first child)
                                   child-markup (last child)
                                   child-coord (conj coord child-key)
                                   old-child-tree (get cached-map child-key)
                                   child-state (get states child-key)]
                               [child-key
                                (if (= (type child-markup) Component)
                                  (expand-component
                                   child-markup
                                   old-child-tree
                                   child-coord
                                   child-state
                                   build-mutate
                                   at-place?
                                   tick
                                   elapsed)
                                  (expand-shape
                                   child-markup
                                   old-child-tree
                                   child-coord
                                   coord
                                   child-state
                                   build-mutate
                                   at-place?
                                   tick
                                   elapsed))]))))]
    (if (some? old-tree)
      (let [merged-children (seq
                             (merge-children
                              []
                              old-children
                              new-children
                              coord
                              states
                              build-mutate
                              at-place?
                              tick
                              elapsed))]
        (assoc markup :coord coord :c-coord c-coord :children merged-children))
      (assoc markup :children new-children :coord coord :c-coord c-coord))))

(defn expand-component [markup old-tree coord states build-mutate at-place? tick elapsed]
  (let [child-coord (conj coord (:name markup))
        existed? (some? old-tree)
        state-tree (get states (:name markup))]
    (comment .log js/console "child-coord:" child-coord)
    (comment .log js/console "component" (:name markup) coord)
    (comment .log js/console states)
    (if existed?
      (let [old-args (:args old-tree)
            old-states (:states old-tree)
            old-instant (:instant old-tree)
            new-args (:args markup)
            old-state (get old-states 'data)
            init-state (:init-state markup)
            new-state (if (contains? state-tree 'data)
                        (get state-tree 'data)
                        (apply init-state new-args))
            on-tick (:on-tick markup)
            on-update (:on-update markup)
            new-instant (-> old-instant
                            (on-tick tick elapsed)
                            (on-update old-args new-args old-state new-state))]
        (if (and (identical? old-states state-tree)
                 (identical? (:render old-tree) (:render markup))
                 (identical? old-instant new-instant)
                 (=seq old-args new-args))
          (do
           (comment println "reusing tree" child-coord)
           (comment println old-args new-args)
           (comment println coord old-states state-tree)
           old-tree)
          (let [mutate! (build-mutate child-coord)
                new-shape (-> (:render markup)
                              (apply new-args)
                              (apply (list new-state mutate! new-instant tick)))
                new-tree (if (= Component (type new-shape))
                           (expand-component
                            new-shape
                            (:tree old-tree)
                            child-coord
                            state-tree
                            build-mutate
                            at-place?
                            tick
                            elapsed)
                           (expand-shape
                            new-shape
                            (:tree old-tree)
                            child-coord
                            child-coord
                            state-tree
                            build-mutate
                            at-place?
                            tick
                            elapsed))]
            (comment .log js/console "existing state" coord state-tree)
            (merge
             old-tree
             {:args new-args, :states state-tree, :instant new-instant, :tree new-tree}))))
      (let [args (:args markup)
            init-state (:init-state markup)
            init-instant (:init-instant markup)
            state (if (contains? state-tree 'data)
                    (get state-tree 'data)
                    (apply init-state args))
            instant (init-instant args state at-place?)
            mutate! (build-mutate child-coord)
            shape (-> (:render markup)
                      (apply args)
                      (apply (list state mutate! instant tick)))
            tree (if (= Component (type shape))
                   (expand-component
                    shape
                    nil
                    child-coord
                    state-tree
                    build-mutate
                    false
                    tick
                    elapsed)
                   (expand-shape
                    shape
                    nil
                    child-coord
                    child-coord
                    state-tree
                    build-mutate
                    false
                    tick
                    elapsed))]
        (merge
         markup
         {:coord child-coord, :args args, :states state-tree, :instant instant, :tree tree})))))

(defn expand-app [markup old-tree states build-mutate tick elapsed]
  (comment .log js/console "caches:" (map first (map key @comp-caches)))
  (let [initial-coord []]
    (expand-component markup old-tree initial-coord states build-mutate true tick elapsed)))

(declare expand-component)

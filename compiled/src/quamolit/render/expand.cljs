
(ns quamolit.render.expand
  (:require [quamolit.alias :refer [Component Shape]]
            [quamolit.util.detect :refer [=vector]]
            [quamolit.util.list :refer [filter-first]]))

(declare expand-component)

(defn merge-children [acc
                      old-children
                      new-children
                      coord
                      states
                      build-mutate
                      at-place?
                      tick
                      elapsed]
  (let [new-n (count new-children)
        old-n (count old-children)
        old-cursor (first old-children)
        new-cursor (first new-children)]
    (cond
      (and (= old-n 0) (= new-n 0)) acc
      (and
        (> old-n 0)
        (> new-n 0)
        (= (key old-cursor) (key new-cursor))) (recur
                                                 (conj
                                                   acc
                                                   [(key new-cursor)
                                                    (val new-cursor)])
                                                 (subvec
                                                   old-children
                                                   1)
                                                 (subvec
                                                   new-children
                                                   1)
                                                 coord
                                                 states
                                                 build-mutate
                                                 at-place?
                                                 tick
                                                 elapsed)
      (and
        (> new-n 0)
        (or
          (= old-n 0)
          (and
            (> old-n 0)
            (= 1 (compare (key old-cursor) (key new-cursor)))))) (let 
                                                                   [child-key
                                                                    (first
                                                                      new-cursor)
                                                                    child
                                                                    (last
                                                                      new-cursor)
                                                                    new-acc
                                                                    (conj
                                                                      acc
                                                                      [child-key
                                                                       child])]
                                                                   (recur
                                                                     new-acc
                                                                     old-children
                                                                     (subvec
                                                                       new-children
                                                                       1)
                                                                     coord
                                                                     states
                                                                     build-mutate
                                                                     at-place?
                                                                     tick
                                                                     elapsed))
      (and
        (> old-n 0)
        (or
          (= new-n 0)
          (and
            (> new-n 0)
            (= -1 (compare (key old-cursor) (key new-cursor)))))) (let 
                                                                    [child-key
                                                                     (first
                                                                       old-cursor)
                                                                     child
                                                                     (last
                                                                       old-cursor)
                                                                     component?
                                                                     (=
                                                                       Component
                                                                       (type
                                                                         child))
                                                                     child-coord
                                                                     (conj
                                                                       coord
                                                                       child-key)
                                                                     new-acc
                                                                     (if
                                                                       component?
                                                                       (if
                                                                         (:fading?
                                                                           child)
                                                                         (if
                                                                           (let 
                                                                             [remove?
                                                                              (:remove?
                                                                                child)]
                                                                             (remove?
                                                                               (:instant
                                                                                 child)))
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
                                                                         (let 
                                                                           [args
                                                                            (:args
                                                                              child)
                                                                            state
                                                                            (:state
                                                                              child)
                                                                            old-instant
                                                                            (:instant
                                                                              child)
                                                                            on-unmount
                                                                            (:on-unmount
                                                                              child)
                                                                            new-instant
                                                                            (on-unmount
                                                                              old-instant)]
                                                                           (conj
                                                                             acc
                                                                             [child-key
                                                                              (assoc
                                                                                child
                                                                                :instant
                                                                                new-instant
                                                                                :fading?
                                                                                true)])))
                                                                       acc)]
                                                                    (recur
                                                                      new-acc
                                                                      (subvec
                                                                        old-children
                                                                        1)
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
  (let [old-children (->> (:children old-tree) (into []))
        new-children (->>
                       (:children markup)
                       (filterv (fn [entry] (some? (last entry))))
                       (mapv
                         (fn [child]
                           (let [child-key (first child)
                                 child-markup (last child)
                                 child-coord (conj coord child-key)
                                 old-child-pair
                                 (->>
                                   old-children
                                   (filter-first
                                     (fn 
                                       [pair]
                                       (identical?
                                         (first pair)
                                         child-key))))
                                 old-child-tree
                                 (if
                                   (some? old-child-pair)
                                   (last old-child-pair)
                                   nil)
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
      (let [merged-children (merge-children
                              []
                              old-children
                              new-children
                              coord
                              states
                              build-mutate
                              at-place?
                              tick
                              elapsed)]
        (assoc
          markup
          :coord
          coord
          :c-coord
          c-coord
          :children
          (into (sorted-map) merged-children)))
      (assoc
        markup
        :children
        new-children
        :coord
        coord
        :c-coord
        c-coord))))

(defn contain-markups? [items]
  (let [result (some
                 (fn [item]
                   (if (or
                         (= Component (type item))
                         (= Shape (type item)))
                     true
                     (if (and (map? item) (> (count item) 0))
                       (some
                         (fn [child]
                           (or
                             (= Component (type child))
                             (= Shape (type child))))
                         (vals item))
                       false)))
                 items)]
    (comment if (not result) (.log js/console result items))
    result))

(defn expand-component [markup
                        old-tree
                        coord
                        states
                        build-mutate
                        at-place?
                        tick
                        elapsed]
  (let [child-coord (conj coord (:name markup))
        existed? (some? old-tree)
        state-tree (get states (:name markup))]
    (comment .log js/console "child-coord:" child-coord)
    (comment .log js/console "component" (:name markup) coord)
    (comment .log js/console states)
    (if existed?
      (let [old-args (:args old-tree)
            old-state (:state old-tree)
            old-instant (:instant old-tree)
            new-args (:args markup)
            maybe-state (get state-tree 'data)
            new-state (if (some? maybe-state) maybe-state old-state)
            on-tick (:on-tick markup)
            on-update (:on-update markup)
            new-instant (-> old-instant
                         (on-tick tick elapsed)
                         (on-update
                           (into [] old-args)
                           (into [] new-args)
                           old-state
                           new-state))]
        (if (and
              (=vector (into [] old-args) (into [] new-args))
              (identical? old-state new-state)
              (identical? (:render old-tree) (:render markup))
              (identical? old-instant new-instant))
          (do
            (comment println "reusing tree" child-coord)
            (comment println old-args new-args)
            old-tree)
          (let [mutate (build-mutate child-coord)
                new-shape (-> (:render markup)
                           (apply new-args)
                           (apply (list new-state mutate))
                           (apply (list new-instant tick)))
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
            (assoc
              old-tree
              :args
              new-args
              :state
              new-state
              :instant
              new-instant
              :tree
              new-tree))))
      (let [args (:args markup)
            init-state (:init-state markup)
            init-instant (:init-instant markup)
            state (apply init-state args)
            instant (init-instant (into [] args) state at-place?)
            mutate (build-mutate child-coord)
            shape (-> (:render markup)
                   (apply args)
                   (apply (list state mutate))
                   (apply (list instant tick)))
            tree (if (= Component (type shape))
                   (expand-component
                     shape
                     nil
                     child-coord
                     states
                     build-mutate
                     false
                     tick
                     elapsed)
                   (expand-shape
                     shape
                     nil
                     child-coord
                     child-coord
                     states
                     build-mutate
                     false
                     tick
                     elapsed))]
        (assoc
          markup
          :coord
          child-coord
          :args
          args
          :state
          state
          :instant
          instant
          :tree
          tree)))))

(defn expand-app [markup old-tree states build-mutate tick elapsed]
  (comment
    .log
    js/console
    "caches:"
    (map first (map key @component-caches)))
  (let [initial-coord []]
    (expand-component
      markup
      old-tree
      initial-coord
      states
      build-mutate
      true
      tick
      elapsed)))

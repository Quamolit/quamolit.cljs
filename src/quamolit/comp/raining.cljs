
(ns quamolit.comp.raining
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp rect group]]
            [quamolit.comp.raindrop :refer [comp-raindrop]]))

(defn random-point [] [(- (rand-int 1400) 600) (- (rand-int 600) 400)])

(defn get-tick [] (.valueOf (js/Date.)))

(defn on-tick [instant tick elapsed]
  (if (> (rand-int 100) 40)
    (conj
      (subvec instant 3)
      [(get-tick) (random-point)]
      [(get-tick) (random-point)]
      [(get-tick) (random-point)])
    instant))

(defn remove? [instant] true)

(defn on-update [instant old-args args old-state state] instant)

(defn render [timestamp]
  (fn [state mutate]
    (fn [instant tick]
      (comment .log js/console (pr-str instant))
      (group
        {}
        (->>
          instant
          (map
            (fn [entry]
              (let [child-key (first entry) child (last entry)]
                [child-key (comp-raindrop child timestamp)]))))))))

(defn init-instant []
  (let [init-val (->>
                   (repeat 80 0)
                   (map-indexed (fn [index x] [index (random-point)]))
                   (into []))]
    init-val))

(defn on-unmount [instant tick] instant)

(def comp-raining
 (create-comp
   :raining
   init-instant
   on-tick
   on-update
   on-unmount
   remove?
   render))


(ns quamolit.comp.fade-in-out
  (:require [quamolit.alias :refer [create-comp]]
            [quamolit.render.element :refer [alpha]]
            [quamolit.util.iterate :refer [iterate-instant]]))

(defn on-tick [instant tick elapsed]
  (let [new-instant (iterate-instant
                      instant
                      :presence
                      :presence-v
                      elapsed
                      [0 1000])]
    (if (and (< (:presence-v instant) 0) (= (:presence new-instant) 0))
      (assoc new-instant :numb? true)
      new-instant)))

(defn on-update [instant old-args args old-state state] instant)

(defn render [props & children]
  (fn [state mutate]
    (fn [instant tick]
      (comment .log js/console instant)
      (alpha
        {:style {:opacity (/ (:presence instant) 1000)}}
        (map-indexed vector children)))))

(defn init-instant [args state]
  {:presence 0, :numb? false, :presence-v 3})

(defn on-unmount [instant tick] (assoc instant :presence-v -3))

(def component-fade-in-out
 (create-comp
   :fade-in-out
   init-instant
   on-tick
   on-update
   on-unmount
   nil
   render))

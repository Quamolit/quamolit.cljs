
(ns quamolit.comp.raindrop
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp rect]]
            [quamolit.render.element :refer [translate alpha]]
            [quamolit.util.iterate :refer [iterate-instant]]))

(defn init-instant [args state at-place?]
  {:presence 0, :presence-v 3, :begin-tick (.valueOf (js/Date.))})

(defn on-tick [instant tick elapsed]
  (iterate-instant instant :presence :presence-v elapsed [0 1000]))

(defn on-unmount [instant tick] (assoc instant :presence-v -3))

(defn on-update [instant old-args args old-state state] instant)

(defn remove? [instant] (and (= 0 (:presence instant)) (= 0 (:presence-v instant))))

(defn render [position timestamp]
  (fn [state mutate! instant tick]
    (let [x (first position), y (last position)]
      (alpha
       {:style {:opacity (* (:presence instant) 0.001)}}
       (rect
        {:style {:fill-style (hsl 200 80 60),
                 :w 4,
                 :h 30,
                 :x x,
                 :y (+ y (* 0.04 (- tick (:begin-tick instant))))}})))))

(def comp-raindrop
  (create-comp :raindrop init-instant on-tick on-update on-unmount remove? render))

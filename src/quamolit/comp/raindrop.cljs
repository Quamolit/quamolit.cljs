
(ns quamolit.comp.raindrop
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp rect]]
            [quamolit.render.element :refer [translate alpha]]
            [quamolit.util.iterate :refer [iterate-instant]]))

(defn on-tick [instant tick elapsed]
  (iterate-instant instant :presence :presence-v elapsed [0 1000]))

(defn remove? [instant] (and (= 0 (:presence instant)) (= 0 (:presence-v instant))))

(defn on-update [instant old-args args old-state state] instant)

(defn render [position timestamp]
  (fn [state mutate! instant tick]
    (let [x (first position), y (last position)]
      (alpha
       {:style {:opacity (* (:presence instant) 0.001)}}
       (rect
        {:style {:y (+ y (* 0.04 (- tick (:begin-tick instant)))),
                 :w 4,
                 :h 30,
                 :fill-style (hsl 200 80 60),
                 :x x}})))))

(defn init-instant [args state at-place?]
  {:begin-tick (.valueOf (js/Date.)), :presence 0, :presence-v 3})

(defn on-unmount [instant tick] (assoc instant :presence-v -3))

(def comp-raindrop
  (create-comp :raindrop init-instant on-tick on-update on-unmount remove? render))


(ns quamolit.comp.solar
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp group rect arc]]
            [quamolit.render.element :refer [rotate translate scale]]))

(declare comp-solar)

(declare render)

(def style-large {:fill-style (hsl 80 80 80), :r 60})

(def style-small {:fill-style (hsl 200 80 80), :r 30})

(defn render [timestamp level]
  (fn [state mutate! instant tick]
    (comment .log js/console :tick (/ tick 10))
    (rotate
     {:style {:angle (rem (/ tick 8) 360)}}
     (arc {:style style-large})
     (translate {:style {:x 100, :y -40}} (arc {:style style-small}))
     (if (> level 0)
       (scale
        {:style {:ratio 0.8}}
        (translate {:style {:x 20, :y 180}} (comp-solar timestamp (- level 1))))))))

(def comp-solar (create-comp :solar render))

(declare comp-solar)

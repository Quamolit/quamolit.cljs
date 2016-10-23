
(ns quamolit.comp.solar
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp group rect arc]]
            [quamolit.render.element :refer [rotate translate scale]]))

(declare comp-solar)

(declare render)

(def style-small {:r 30, :fill-style (hsl 200 80 80)})

(def style-large {:r 60, :fill-style (hsl 80 80 80)})

(defn render [timestamp level]
  (fn [state mutate]
    (fn [instant tick]
      (comment .log js/console :tick (/ tick 10))
      (rotate
        {:style {:angle (rem (/ tick 8) 360)}}
        (arc {:style style-large})
        (translate
          {:style {:y -40, :x 100}}
          (arc {:style style-small}))
        (if (> level 0)
          (scale
            {:style {:ratio 0.8}}
            (translate
              {:style {:y 180, :x 20}}
              (comp-solar timestamp (- level 1)))))))))

(def comp-solar (create-comp :solar render))

(declare comp-solar)


(ns quamolit.component.folding-fan
  (:require [quamolit.alias :refer [text create-comp group image]]
            [quamolit.render.element :refer [button translate rotate]]
            [hsl.core :refer [hsl]]))

(defn render []
  (fn [state mutate]
    (fn [instant]
      (let [n 12
            image-w 650
            image-h 432
            image-unit (/ image-w n)
            dest-w 650
            dest-h 432
            dest-unit (/ dest-w n)]
        (translate
          {:style {:y 160, :x 0}}
          (->>
            (range n)
            (map
              (fn [i] [i
                       (rotate
                         {:style {:angle (* 12 (+ 0.5 (- i (/ n 2))))}}
                         (image
                           {:style
                            {:dh dest-h,
                             :dx (- 0 (/ image-unit 2)),
                             :sy 0,
                             :dy (- 10 dest-h),
                             :src "lotus.jpg",
                             :dw dest-unit,
                             :sx (* i image-unit),
                             :sh image-h,
                             :sw image-unit}}))]))
            (into (sorted-map))))))))

(def comp-folding-fan (create-comp :folding-fan render))

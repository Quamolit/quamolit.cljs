
(ns quamolit.comp.binary-tree
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp line group path]]
            [quamolit.render.element :refer [rotate scale translate]]
            [quamolit.comp.debug :refer [comp-debug]]))

(declare comp-binary-tree)

(declare render)

(defn render [timestamp level]
  (fn [state mutate! instant tick]
    (let [r1 0.6
          r2 0.9
          r3 0.5
          r4 0.6
          x1 80
          y1 -220
          x1-2 10
          y1-2 -80
          x2 -140
          y2 -100
          shift-a (* (+ 0.02 (* 0.001 r1)) (js/Math.sin (/ tick (+ 800 (* r2 100)))))
          shift-b (* (+ 0.03 (* 0.001 r3)) (js/Math.sin (/ tick (+ 1300 (* 60 r4)))))]
      (group
       {}
       (path {:style {:points [[x1 y1] [0 0] [x2 y2]], :stroke-style (hsl 200 80 50)}})
       (if (> level 0)
         (translate
          {:style {:x x1, :y y1}}
          (scale
           {:style {:ratio (+ 0.6 (* 1.3 shift-a))}}
           (rotate
            {:style {:angle (+ (* 30 shift-a) 10)}}
            (comp-binary-tree timestamp (dec level))))))
       (if (> level 0)
         (translate
          {:style {:x x2, :y y2}}
          (scale
           {:style {:ratio (+ 0.73 (* 2 shift-b))}}
           (rotate
            {:style {:angle (+ (* 20 shift-b) 10)}}
            (comp-binary-tree timestamp (dec level))))))))))

(def comp-binary-tree (create-comp :binary-tree render))

(declare comp-binary-tree)

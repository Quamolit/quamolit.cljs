
(ns quamolit.comp.binary-tree
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp line group path]]
            [quamolit.render.element :refer [rotate scale translate]]))

(declare comp-binary-tree)

(declare render)

(defn init-state [] [(js/Math.random) (js/Math.random) (js/Math.random) (js/Math.random)])

(defn render [timestamp level]
  (fn [state mutate! instant tick]
    (let [[r1 r2 r3 r4] state
          x1 120
          y1 -220
          x1-2 10
          y1-2 -80
          x2 -140
          y2 -100
          shift-a (* (+ 0.02 (* 0.001 r1)) (js/Math.sin (/ tick (+ (* r2 100) 800))))
          shift-b (* (+ 0.03 (* 0.001 r3)) (js/Math.sin (/ tick (+ 1300 (* 60 r4)))))]
      (group
       {}
       (path {:style {:stroke-style (hsl 200 80 50), :points [[x1 y1] [0 0] [x2 y2]]}})
       (if (> level 0)
         (translate
          {:style {:y y1, :x x1}}
          (scale
           {:style {:ratio (+ (* 0.2 shift-a) 0.5)}}
           (rotate
            {:style {:angle (+ (* 3 shift-a) 10)}}
            (comp-binary-tree timestamp (dec level))))))
       (if (> level 0)
         (translate
          {:style {:y y2, :x x2}}
          (scale
           {:style {:ratio (+ 0.83 (* 2 shift-b))}}
           (rotate
            {:style {:angle (+ (* 50 shift-b) 10)}}
            (comp-binary-tree timestamp (dec level))))))))))

(def comp-binary-tree (create-comp :binary-tree init-state merge render))

(declare comp-binary-tree)

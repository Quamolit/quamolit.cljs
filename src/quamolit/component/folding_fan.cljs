
(ns quamolit.component.folding-fan
  (:require [quamolit.alias :refer [text create-comp group image]]
            [quamolit.render.element :refer [button translate rotate]]
            [hsl.core :refer [hsl]]
            [quamolit.util.iterate :refer [iterate-instant tween]]))

(defn on-tick [instant tick elapsed]
  (iterate-instant instant :folding-value :folding-v elapsed [0 1000]))

(defn update-state [state] (not state))

(defn handle-toggle [mutate] (fn [e dispatch] (mutate)))

(defn removable? [instant] true)

(defn on-update [instant old-args old-state args state]
  (if (not= old-state state)
    (assoc instant :folding-v (if state 2 -2))
    instant))

(defn init-state [] true)

(defn render []
  (fn [state mutate]
    (fn [instant]
      (let [n 24
            image-w 650
            image-h 432
            image-unit (/ image-w n)
            dest-w 650
            dest-h 432
            dest-unit (/ dest-w n)]
        (group
          {}
          (translate
            {:style {:y 160, :x 0}}
            (->>
              (range n)
              (map
                (fn [i] [i
                         (rotate
                           {:style
                            {:angle
                             (*
                               (tween
                                 [0 6]
                                 [0 1000]
                                 (:folding-value instant))
                               (+ 0.5 (- i (/ n 2))))}}
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
                               :sw image-unit}}))]))))
          (button
            {:style
             {:y 200,
              :surface-color (hsl 30 80 60),
              :text-color (hsl 0 0 100),
              :x 160,
              :text "Toggle"},
             :event {:click (handle-toggle mutate)}}))))))

(defn init-instant [args state]
  {:folding-v 0, :folding-value (if state 1000 0)})

(defn on-unmount [instant tick] instant)

(def comp-folding-fan
 (create-comp
   :folding-fan
   init-state
   update-state
   init-instant
   on-tick
   on-update
   on-unmount
   removable?
   render))

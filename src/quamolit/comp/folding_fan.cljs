
(ns quamolit.comp.folding-fan
  (:require [quamolit.alias :refer [text create-comp group image]]
            [quamolit.render.element :refer [button translate rotate]]
            [hsl.core :refer [hsl]]
            [quamolit.util.iterate :refer [iterate-instant tween]]))

(defn handle-toggle [mutate!] (fn [e dispatch] (mutate!)))

(defn init-instant [args state] {:folding-value (if state 1000 0), :folding-v 0})

(defn init-state [] true)

(defn on-tick [instant tick elapsed]
  (iterate-instant instant :folding-value :folding-v elapsed [0 1000]))

(defn on-unmount [instant tick] instant)

(defn on-update [instant old-args old-state args state]
  (if (not= old-state state) (assoc instant :folding-v (if state 2 -2)) instant))

(defn remove? [instant] true)

(defn render []
  (fn [state mutate! instant tick]
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
        {:style {:x 0, :y 160}}
        (->> (range n)
             (map
              (fn [i]
                [i
                 (rotate
                  {:style {:angle (*
                                   (tween [0 6] [0 1000] (:folding-value instant))
                                   (+ 0.5 (- i (/ n 2))))}}
                  (image
                   {:style {:src "lotus.jpg",
                            :sx (* i image-unit),
                            :sy 0,
                            :sw image-unit,
                            :sh image-h,
                            :dx (- 0 (/ image-unit 2)),
                            :dy (- 10 dest-h),
                            :dw dest-unit,
                            :dh dest-h}}))]))))
       (button
        {:style {:text "Toggle",
                 :x 160,
                 :y 200,
                 :surface-color (hsl 30 80 60),
                 :text-color (hsl 0 0 100)},
         :event {:click (handle-toggle mutate!)}})))))

(defn update-state [state] (not state))

(def comp-folding-fan
  (create-comp
   :folding-fan
   init-state
   update-state
   init-instant
   on-tick
   on-update
   on-unmount
   remove?
   render))

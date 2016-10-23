
(ns quamolit.comp.file-card
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp group rect text]]
            [quamolit.render.element :refer [translate alpha scale]]
            [quamolit.util.iterate :refer [iterate-instant]]))

(defn on-tick [instant tick elapsed]
  (let [new-instant (-> instant
                     (iterate-instant
                       :presence
                       :presence-v
                       elapsed
                       [0 1000])
                     (iterate-instant
                       :popup
                       :popup-v
                       elapsed
                       [0 1000]))]
    (if (and (< (:presence-v instant) 0) (= (:presence new-instant) 0))
      (assoc new-instant :numb? true)
      new-instant)))

(defn handle-click [navigate-this index popup?]
  (fn [event dispatch] (navigate-this (if popup? nil index))))

(defn on-update [instant old-args args old-state state]
  (let [old-popup? (last old-args) popup? (last args)]
    (if (= old-popup? popup?)
      instant
      (assoc instant :popup-v (if popup? 3 -3)))))

(defn render [card-name
              position
              navigate-this
              index
              parent-ratio
              popup?]
  (fn [state mutate]
    (fn [instant tick]
      (let [popup-ratio (/ (:popup instant) 1000)
            shift-x (first position)
            shift-y (last position)
            move-x (* shift-x (+ 0.1 (* 0.9 (- 1 popup-ratio))))
            move-y (* shift-y (+ 0.1 (* 0.9 (- 1 popup-ratio))))
            scale-ratio (/ (+ 0.2 (* 0.8 popup-ratio)) parent-ratio)]
        (translate
          {:style {}}
          (alpha
            {:style {:opacity (/ (:presence instant) 1000)}}
            (translate
              {:style {:y move-y, :x move-x}}
              (scale
                {:style {:ratio scale-ratio}}
                (rect
                  {:style
                   {:w 520, :h 360, :fill-style (hsl 200 80 80)},
                   :event
                   {:click (handle-click navigate-this index popup?)}}
                  (text
                    {:style
                     {:size 60,
                      :fill-style (hsl 0 0 100),
                      :text card-name}}))))))))))

(defn init-instant []
  {:popup 0, :presence 0, :numb? false, :popup-v 0, :presence-v 3})

(defn on-unmount [instant tick] (assoc instant :presence-v -3))

(def component-file-card
 (create-comp
   :file-card
   init-instant
   on-tick
   on-update
   on-unmount
   nil
   render))

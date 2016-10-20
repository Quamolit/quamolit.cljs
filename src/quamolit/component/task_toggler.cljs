
(ns quamolit.component.task-toggler
  (:require [hsl.core :refer [hsl]]
            [quamolit.util.iterate :refer [iterate-instant tween]]
            [quamolit.alias :refer [create-comp group rect]]))

(defn on-tick [instant tick elapsed]
  (iterate-instant instant :done-value :done-velocity elapsed [0 1000]))

(defn handle-click [task-id]
  (fn [event dispatch] (dispatch :toggle task-id)))

(defn on-update [instant old-args args old-state state]
  (let [old-done? (first old-args) done? (first args)]
    (if (not= old-done? done?)
      (assoc
        instant
        :done-velocity
        (if (> (:done-value instant) 500) -3 3))
      instant)))

(defn style-toggler [done-value]
  {:w 40,
   :h 40,
   :fill-style
   (hsl
     (tween [360 200] [0 1000] done-value)
     80
     (tween [40 80] [0 1000] done-value))})

(defn render [done? task-id]
  (fn [state mutate]
    (fn [instant]
      (comment .log js/console "done:" instant)
      (rect
        {:style (style-toggler (:done-value instant)),
         :event {:click (handle-click task-id)}}))))

(defn init-instant [args state]
  (let [done? (first args)]
    {:numb? true, :done-value (if done? 0 1000), :done-velocity 0}))

(def component-toggler
 (create-comp
   :task-toggler
   nil
   nil
   init-instant
   on-tick
   on-update
   nil
   nil
   render))

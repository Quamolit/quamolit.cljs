
(ns quamolit.comp.icons-table
  (:require [quamolit.alias :refer [create-comp text line group]]
            [quamolit.render.element :refer [translate]]
            [quamolit.comp.icon-increase :refer [comp-icon-increase]]
            [quamolit.comp.icon-play :refer [comp-icon-play]]))

(defn render [timestamp]
  (fn [state mutate]
    (fn [instant]
      (group
        {}
        (translate {:style {:x -200}} (comp-icon-increase))
        (translate {:style {:x 0}} (comp-icon-play))))))

(def comp-icons-table (create-comp :icons-table render))

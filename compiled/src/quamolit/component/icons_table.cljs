
(ns quamolit.component.icons-table
  (:require [quamolit.alias :refer [create-comp text line group]]
            [quamolit.render.element :refer [translate]]
            [quamolit.component.icon-increase :refer [comp-icon-increase]]
            [quamolit.component.icon-play :refer [component-icon-play]]))

(defn render []
  (fn [state mutate]
    (fn [instant]
      (group
        {}
        (translate {:style {:x -200}} (comp-icon-increase))
        (translate {:style {:x 0}} (component-icon-play))))))

(def component-icons-table (create-comp :icons-table render))

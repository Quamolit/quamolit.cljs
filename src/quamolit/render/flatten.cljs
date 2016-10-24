
(ns quamolit.render.flatten
  (:require [quamolit.util.order :refer [by-coord]] [quamolit.types :refer [Component]]))

(defn flatten-tree [tree]
  (if (= Component (type tree))
    (recur (:tree tree))
    (let [this-directive [(:coord tree) (:name tree) (:style tree)]
          child-directives (map
                             (fn [child-entry] (flatten-tree (last child-entry)))
                             (:children tree))
          all-directives (cons this-directive (apply concat child-directives))]
      all-directives)))

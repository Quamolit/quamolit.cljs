
ns quamolit.render.flatten $ :require
  [] quamolit.util.order :refer $ [] by-coord

defn flatten-tree (tree)
  if
    = :component $ :type tree
    recur $ :tree tree
    let
      (this-directive $ [] (:coord tree) (:name tree) (:style $ :props tree))
        child-directives $ map
          fn (child)
            flatten-tree $ val child
          :children tree

        all-directives $ cons this-directive (apply concat child-directives)

      , all-directives

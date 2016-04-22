
ns quamolit.controller.gc $ :require
  [] quamolit.alias :refer $ [] Component Shape

defn find-component-coords (markup)
  if
    = Component $ type markup
    cons
      find-component-coords $ :tree markup
      :coord markup
    ->> (:children markup)
      fn (child-entry)
        find-component-coords $ val child-entry

defn states-gc (states tree)
  let
    (coords $ find-component-coords tree)
    ->> states
      filter $ fn (entry)
        some
          fn (x)
            = x $ key entry
          , coords

      into $ sorted-map


ns quamolit.util.detect

defn map-of-children? (x)
  and (map? x)
    every?
      fn (entry)
        and
          map? $ val entry
          contains? (val entry)
            , :type

      , x
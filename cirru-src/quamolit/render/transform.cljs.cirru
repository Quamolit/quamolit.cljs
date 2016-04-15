
ns quamolit.render.transform

defn filter-components (markup)
  if
    = (:type markup)
      , :component
    [] markup
    apply concat $ ->> markup (:children)
      map val
      map filter-components

defn filter-shapes (markup)
  if
    = (:type markup)
      , :component
    , nil
    update markup :children $ fn (children)
      ->> children
        filter $ fn (entry)
          let
            (markup-value $ val entry)
            = (:type markup-value)
              , :shape

        map $ fn (entry)
          let
            (markup-key $ key entry)
              markup-value $ val entry
            [] markup-key $ filter-shapes markup

        into $ sorted-map

defn pick-components
  (tree)
    pick-components tree $ {}
  (tree acc)
    let
      (components-inside $ filter-components (:shape tree))
        component-only-shape $ update tree :shape filter-shapes

      -> acc
        merge $ apply merge (map pick-components components-inside)
        assoc (:coord tree)
          , component-only-shape

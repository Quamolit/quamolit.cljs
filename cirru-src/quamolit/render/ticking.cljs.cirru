
ns quamolit.render.ticking

declare ticking-component

defn ticking-shape
  markup old-tree coord c-coord states
  let
    (old-children $ :children old-tree)
      new-children $ ->> (:children markup)
        map $ fn (child)
          let
            (child-key $ key child)
              child-markup $ val child
              child-coord $ conj coord child-key
              old-child-tree $ get old-children child-key
            [] child-key $ if
              = :component $ :type child-markup
              ticking-component child-markup old-child-tree old-tree coord states
              ticking-shape child-markup old-child-tree child-coord coord states

        filter $ fn (child)
          some? $ val child
        into $ sorted-map

    assoc markup :children new-children

defn ticking-component
  markup old-tree coord states
  let
    (existed? $ some? old-tree)
    if existed?
      let
        (args $ :args old-tree)
          state $ :state old-tree
          old-instant $ :instant old-tree
          on-tick $ :on-tick old-tree
          new-instant $ on-tick old-instant args state
          new-shape $ -> (:render markup)
            apply args
            apply $ list state
            apply $ list new-instant
          new-tree $ ticking-shape new-shape (:tree old-tree)
            , coord coord states

        assoc old-tree :instant new-instant :tree new-tree

      , nil

defn ticking-app (markup old-tree states)
  let
    (initial-coord $ [])
    ticking-component markup old-tree initial-coord states


ns quamolit.render.ticking

declare ticking-component

defn merge-children (acc old-children new-children)
  let
    (old-n $ count old-children)
      new-n $ count new-children
    cond
      (= 0 old-n new-n) acc
      (and (> old-n 0) (> new-n 0) (and $ = (key $ first old-children) (key $ first new-children)))
        recur
          assoc acc
            key $ first new-children
            val $ first new-children
          rest old-children
          rest new-children

      (and (> old-n 0) (or (= new-n 0) (and (> old-n 0) (= -1 $ compare (key $ first old-children) (key $ first new-children)))))
        recur
          let
            (cursor $ first old-children)
              this-key $ key cursor
              this-child $ val cursor
            if
              = :component $ :type this-child
              let
                (numb? $ get-in this-child ([] :instant :numb?))

                .log js/console "|drop or not:" this-child
                if numb? acc $ assoc acc this-key this-child

              , acc

          rest old-children
          , new-children

      (and (> new-n 0) (or (= old-n 0) (and (> new-n 0) (= 1 $ compare (key $ first old-children) (key $ first new-children)))))
        recur
          let
            (cursor $ first new-children)
              this-key $ key cursor
              this-child $ val cursor
            if
              = :component $ :type this-child
              , acc
              assoc acc this-key this-child

          , old-children
          rest new-children

      :else acc

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
              ticking-component child-markup old-child-tree coord states
              ticking-shape child-markup old-child-tree child-coord coord states

        filter $ fn (child)
          some? $ val child
        into $ sorted-map

    assoc old-tree :children $ merge-children (sorted-map)
      , old-children new-children

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

      do (.log js/console old-tree)
        , nil

defn ticking-app (markup old-tree states)
  let
    (initial-coord $ [])
    ticking-component markup old-tree initial-coord states

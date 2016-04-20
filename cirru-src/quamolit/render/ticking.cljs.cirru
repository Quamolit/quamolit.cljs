
ns quamolit.render.ticking $ :require
  [] quamolit.alias :refer $ [] Component

declare ticking-component

defn merge-children
  acc old-children new-children coord states build-mutate tick elapsed
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
          , coord states build-mutate tick elapsed

      (and (> old-n 0) (or (= new-n 0) (and (> new-n 0) (= -1 $ compare (key $ first old-children) (key $ first new-children)))))
        recur
          let
            (cursor $ first old-children)
              this-key $ key cursor
              this-child $ val cursor
            if
              = Component $ type this-child
              let
                (numb? $ get-in this-child ([] :instant :numb?))

                -- .log js/console "|drop or not:" this-child
                if numb? acc $ assoc acc this-key
                  ticking-component this-child this-child (conj coord this-key)
                    , states build-mutate tick elapsed

              , acc

          rest old-children
          , new-children coord states build-mutate tick elapsed

      (and (> new-n 0) (or (= old-n 0) (and (> old-n 0) (= 1 $ compare (key $ first old-children) (key $ first new-children)))))
        recur
          let
            (cursor $ first new-children)
              this-key $ key cursor
              this-child $ val cursor
            if
              = Component $ type this-child
              , acc
              assoc acc this-key this-child

          , old-children
          rest new-children
          , coord states build-mutate tick elapsed

      :else acc

defn ticking-shape
  markup old-tree coord c-coord states build-mutate tick elapsed
  let
    (old-children $ :children old-tree)
      new-children $ ->> (:children markup)
        map $ fn (child)
          let
            (child-key $ first child)
              child-markup $ last child
              child-coord $ conj coord child-key
              old-child-tree $ get old-children child-key
            [] child-key $ if
              = Component $ type child-markup
              ticking-component child-markup old-child-tree child-coord states build-mutate tick elapsed
              ticking-shape child-markup old-child-tree child-coord coord states build-mutate tick elapsed

        filter $ fn (child)
          some? $ val child
        into $ sorted-map

    assoc old-tree :props (:props markup)
      , :children
      into (sorted-map)
        merge-children (sorted-map)
          , old-children new-children coord states build-mutate tick elapsed

defn ticking-component
  markup old-tree coord states build-mutate tick elapsed
  let
    (existed? $ some? old-tree)
    let
      (args $ :args markup)
        state $ or (get states coord)
          if existed? (:state old-tree)
            let
              (init-state $ :init-state markup)
                initial-state $ apply init-state args
              , initial-state

        old-instant $ if existed? (:instant old-tree)
          let
            (init-instant $ :init-instant markup)
            apply init-instant $ list args state

        on-tick $ :on-tick markup
        new-instant $ if existed?
          on-tick old-instant tick elapsed
          , old-instant
        mutate $ build-mutate coord state (:update-state markup)
        new-shape $ -> (:render markup)
          apply args
          apply $ list state mutate
          apply $ list new-instant tick
        new-tree $ ticking-shape new-shape
          if existed? (:tree old-tree)
            , nil
          , coord coord states build-mutate tick elapsed

      if existed?
        assoc old-tree :instant new-instant :tree new-tree :args args
        assoc markup :coord coord :state :state :instant new-instant :tree new-tree

defn ticking-app
  markup old-tree states build-mutate tick elapsed
  let
    (initial-coord $ [])
    ticking-component markup old-tree initial-coord states build-mutate tick elapsed

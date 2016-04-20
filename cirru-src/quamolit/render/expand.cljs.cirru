
ns quamolit.render.expand $ :require
  [] quamolit.alias :refer $ [] Component

declare expand-component

defn merge-children
  acc old-children new-children coord states build-mutate at-place? tick elapsed
  let
    (new-n $ count new-children)
      old-n $ count old-children
      old-cursor $ first old-children
      new-cursor $ first new-children
    cond
      (and (= old-n 0) (= new-n 0)) acc

      (and (> old-n 0) (> new-n 0) (= (key old-cursor) (key new-cursor)))
        recur
          assoc acc (key new-cursor)
            val new-cursor
          rest old-children
          rest new-children
          , coord states build-mutate at-place? tick elapsed

      (and (> new-n 0) (or (= old-n 0) (and (> old-n 0) (= 1 $ compare (key old-cursor) (key new-cursor)))))
        let
          (child-key $ first new-cursor)
            child $ last new-cursor
            new-acc $ assoc acc child-key child
          recur new-acc old-children (rest new-children)
            , coord states build-mutate at-place? tick elapsed

      (and (> old-n 0) (or (= new-n 0) (and (> new-n 0) (= -1 $ compare (key old-cursor) (key new-cursor)))))
        let
          (child-key $ first old-cursor)
            child $ last old-cursor
            component? $ = Component (type child)
            child-coord $ conj coord child-key
            new-acc $ if component?
              if (:fading? child)
                if
                  get-in child $ [] :instant :numb?
                  , acc
                  assoc acc child-key $ expand-component child child child-coord states build-mutate at-place? tick elapsed
                let
                  (args $ :args child)
                    state $ :state child
                    old-instant $ :instant child
                    on-unmount $ :on-unmount child
                    new-instant $ on-unmount old-instant
                  assoc acc child-key $ assoc child :instant new-instant :fading? true

              , acc

          recur new-acc (rest old-children)
            , new-children coord states build-mutate at-place? tick elapsed

      :else acc

defn expand-shape
  markup old-tree coord c-coord states build-mutate at-place? tick elapsed
  let
    (old-children $ :children old-tree)
      new-children $ ->> (:children markup)
        map $ fn (child)
          let
            (child-key $ key child)
              child-markup $ val child
              child-coord $ conj coord child-key
              old-child-tree $ if (some? old-tree)
                get old-children child-key
                , nil

            [] child-key $ if
              = (type child-markup)
                , Component
              expand-component child-markup old-child-tree child-coord states build-mutate at-place? tick elapsed
              expand-shape child-markup old-child-tree child-coord coord states build-mutate at-place? tick elapsed

        filter $ fn (entry)
          some? $ val entry
        into $ sorted-map

    if (some? old-tree)
      assoc markup :coord coord :c-coord c-coord :children $ into (sorted-map)
        merge-children ({})
          , old-children new-children coord states build-mutate at-place? tick elapsed

      assoc markup :children new-children :coord coord :coord c-coord

defn expand-component
  markup old-tree coord states build-mutate at-place? tick elapsed
  let
    (child-coord $ conj coord 0)
      existed? $ some? old-tree
    -- .log js/console |component (:name markup)
      , coord
    -- .log js/console states
    if existed?
      let
        (old-args $ :args old-tree)
          old-state $ :state old-tree
          old-instant $ :instant old-tree
          new-args $ :args markup
          new-state $ or (get states coord)
            , old-state
          on-tick $ :on-tick markup
          on-update $ :on-update markup
          update-state $ :update-state markup
          new-instant $ -> old-instant (on-tick tick elapsed)
            on-update old-args new-args old-state new-state
          mutate $ build-mutate coord old-state update-state
          new-shape $ -> (:render markup)
            apply new-args
            apply $ list new-state mutate
            apply $ list new-instant tick
          new-tree $ if
            = Component $ type new-shape
            expand-component new-shape (:tree old-tree)
              , child-coord states build-mutate at-place? tick elapsed
            expand-shape new-shape (:tree old-tree)
              , child-coord child-coord states build-mutate at-place? tick elapsed

        -- .log js/console "|existing state" coord $ get states coord
        assoc old-tree :args new-args :state new-state :instant new-instant :tree new-tree

      let
        (args $ :args markup)
          init-state $ :init-state markup
          init-instant $ :init-instant markup
          update-state $ :update-state markup
          state $ apply init-state args
          instant $ init-instant args state
          mutate $ build-mutate coord state update-state
          shape $ -> (:render markup)
            apply args
            apply $ list state mutate
            apply $ list instant tick
          tree $ if
            = Component $ type shape
            expand-component shape nil child-coord states build-mutate at-place? tick elapsed
            expand-shape shape nil child-coord child-coord states build-mutate false tick elapsed

        Component. (:name markup)
          , coord args state instant
          :render markup
          :init-state markup
          :update-state markup
          :init-instant markup
          :on-tick markup
          :on-update markup
          :on-unmount markup
          , tree false

defn expand-app
  markup old-tree states build-mutate tick elapsed
  let
    (initial-coord $ [])
    expand-component markup old-tree initial-coord states build-mutate true tick elapsed

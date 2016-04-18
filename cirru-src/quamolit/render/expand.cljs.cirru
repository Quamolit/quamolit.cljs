
ns quamolit.render.expand

declare expand-component

defn merge-children
  (old-children new-children)
    merge-children (sorted-map)
      , old-children new-children

  (acc old-children new-children)
    cond
      (and (= (count old-children) (, 0)) (= (count new-children) (, 0))) acc

      (and (= (count old-children) (, 0)) (> (count new-children) (, 0)))
        let
          (cursor $ first new-children)
            child-key $ first cursor
            child $ last cursor
            new-acc $ assoc acc child-key child
          merge-children new-acc (list)
            rest new-children

      (and (> (count old-children) (, 0)) (= (count new-children) (, 0)))
        let
          (cursor $ first old-children)
            child-key $ first cursor
            child $ last cursor
            component? $ = :component (:type child)
            new-acc $ if component?
              if (:fading? child)
                assoc acc child-key child
                let
                  (args $ :args child)
                    state $ :state child
                    old-instant $ :instant child
                    on-unmount $ :on-unmount child
                    new-instant $ on-unmount old-instant
                  assoc acc child-key $ assoc child :instant new-instant :fading? true

              , acc

          merge-children new-acc (rest old-children)
            list

      :else $ let
        (old-cursor $ first old-children)
          old-key $ first old-cursor
          new-cursor $ first new-children
          new-key $ first new-cursor
        case (compare old-key new-key)
          -1 $ let
            (cursor $ first old-children)
              child-key $ first cursor
              child $ last cursor
              component? $ = :component (:type child)
              new-acc $ if component?
                if (:fading? child)
                  assoc acc child-key child
                  let
                    (args $ :args child)
                      state $ :state child
                      old-instant $ :instant child
                      on-unmount $ :on-unmount child
                      new-instant $ on-unmount old-instant
                    assoc acc child-key $ assoc child :instant new-instant :fading? true

                , acc

          1 $ let
            (new-acc $ assoc acc new-key (last new-cursor))

            merge-children new-acc old-children $ rest new-children

          let
            (new-acc $ assoc acc new-key (last new-cursor))

            merge-children new-acc (rest old-children)
              rest new-children

defn expand-shape
  markup old-tree coord c-coord states build-mutate at-place?
  if (some? old-tree)
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
                = (:type child-markup)
                  , :component
                expand-component child-markup old-child-tree child-coord states build-mutate at-place?
                expand-shape child-markup old-child-tree child-coord coord states build-mutate at-place?

          into $ sorted-map

      assoc markup :children (merge-children old-children new-children)
        , :coord coord :c-coord c-coord

    let
      (new-children $ ->> (:children markup) (map $ fn (child) (let ((child-key $ key child) (child-markup $ val child) (child-coord $ conj coord child-key)) ([] child-key $ if (= (:type child-markup) (, :component)) (expand-component child-markup nil child-coord states build-mutate at-place?) (expand-shape child-markup nil child-coord coord states build-mutate at-place?)))) (into $ sorted-map))

      assoc markup :children new-children :coord coord :c-coord c-coord

defn expand-component
  markup old-tree coord states build-mutate at-place?
  let
    (existed? $ some? old-tree)
    -- .log js/console |component (:name markup)
      , coord
    if existed?
      let
        (old-args $ :args old-tree)
          old-state $ :state old-tree
          old-instant $ :instant old-tree
          new-args $ :args markup
          new-state $ or (get states coord)
            , old-state
          on-update $ :on-update markup
          new-instant $ on-update old-instant old-args new-args old-state new-state
          mutate $ build-mutate coord old-state (:update-state markup)
          new-shape $ -> (:render markup)
            apply new-args
            apply $ list new-state mutate
            apply $ list new-instant
          new-tree $ expand-shape new-shape (:tree old-tree)
            , coord coord states build-mutate at-place?

        -- .log js/console "|existing state" coord $ get states coord
        assoc old-tree :args new-args :state new-state :instant new-instant :tree new-tree

      let
        (args $ :args markup)
          init-state $ :init-state markup
          state $ apply init-state args
          initial-instant $ ->
            or (:init-instant markup)
              fn (& some-args)
                fn (state)
                  {} :numb? true

            apply args
            apply $ list state

          on-mount $ :on-mount markup
          instant $ on-mount initial-instant args state at-place?
          mutate $ build-mutate coord state (:update-state markup)
          shape $ -> (:render markup)
            apply args
            apply $ list state mutate
            apply $ list instant
          tree $ expand-shape shape nil coord coord states build-mutate false

        {}
          :name $ :name markup
          :args args
          :state state
          :instant instant
          :type :component
          :coord coord
          :tree tree
          :fading? false
          :on-unmount $ :on-unmount markup
          :on-update $ :on-update markup
          :on-tick $ :on-tick markup

defn expand-app
  markup old-tree states build-mutate
  let
    (initial-coord $ [])
    expand-component markup old-tree initial-coord states build-mutate true

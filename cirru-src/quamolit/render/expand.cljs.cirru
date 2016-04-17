
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
  markup old-tree coord c-coord states at-place?
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
                expand-component child-markup old-child-tree child-coord states at-place?
                expand-shape child-markup old-child-tree child-coord coord states at-place?

          into $ sorted-map

      assoc markup :children $ merge-children old-children new-children

    let
      (new-children $ ->> (:children markup) (map $ fn (child) (let ((child-key $ key child) (child-markup $ val child) (child-coord $ conj coord child-key)) ([] child-key $ if (= (:type child-markup) (, :component)) (expand-component child-markup nil child-coord states at-place?) (expand-shape child-markup nil child-coord coord states at-place?)))) (into $ sorted-map))

      assoc markup :children new-children

defn expand-component
  markup old-tree coord states at-place?
  let
    (existed? $ some? old-tree)
    if existed?
      let
        (old-args $ :args old-tree)
          old-state $ :state old-tree
          old-instant $ :state old-tree
          new-args $ :args markup
          new-state $ get states coord
          on-update $ :on-update markup
          new-instant $ on-update old-instant old-args new-args old-state new-state
          new-shape $ -> (:render markup)
            apply new-args
            apply $ list new-state
            apply $ list new-instant
          new-tree $ expand-shape new-shape (:tree old-tree)
            , coord coord states at-place?

        assoc old-tree :args new-args :state new-state :instant new-instant :tree new-tree

      let
        (args $ :args markup)
          init-state $ :init-state markup
          state $ apply init-state args
          init-instant $ :init-instant markup
          init-instant-with-args $ apply init-instant args
          initial-instant $ init-instant-with-args state
          on-mount $ :on-mount markup at-place?
          instant $ on-mount initial-instant args state
          shape $ -> (:render markup)
            apply args
            apply $ list state
            apply $ list instant
          tree $ expand-shape shape nil coord coord states false

        {}
          :name $ :name markup
          :args args
          :state state
          :instant instant
          :type :component
          :coord coord
          :tree tree
          :fading false

defn expand-app (markup old-tree states)
  let
    (initial-coord $ [] 0)
    expand-component markup old-tree initial-coord states true


ns quamolit.render.expand $ :require
  [] quamolit.alias :refer $ [] Component Shape

declare expand-component

defonce component-caches $ atom ({})

defn add-cache! (data-path data)
  swap! component-caches assoc data-path $ {} :data data :value 10

defn hit-cache! (data-path)
  swap! component-caches update-in ([] data-path :value)
    fn (value)
      if (< value 40)
        + value 3
        , 40

defn dec-cache! ()
  reset! component-caches $ ->> @component-caches
    map $ fn (entry)
      [] (key entry)
        update (val entry)
          , :value dec

    filter $ fn (entry)
      >
        :value $ last entry
        , 0

    into $ {}

defn get-cache (data-path)
  get @component-caches data-path

defn detect-animating? (markup)
  if
    = Component $ type markup
    let
      (animate? $ :animate? markup)
      or
        animate? $ :instant markup
        :fading? markup
        detect-animating? $ :tree markup

    :animating? markup

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
                  let
                    (remove? $ :remove? child)
                    remove? $ :instant child

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
        filter $ fn (entry)
          some? $ val entry
        map $ fn (child)
          let
            (child-key $ first child)
              child-markup $ last child
              child-coord $ conj coord child-key
              old-child-tree $ if (some? old-tree)
                get old-children child-key
                , nil

            [] child-key $ if
              = (type child-markup)
                , Component
              expand-component child-markup old-child-tree child-coord states build-mutate at-place? tick elapsed
              expand-shape child-markup old-child-tree child-coord coord states build-mutate at-place? tick elapsed

        into $ sorted-map

    if (some? old-tree)
      let
        (merged-children $ merge-children ({}) (, old-children new-children coord states build-mutate at-place? tick elapsed))
          animating? $ some
            fn (entry)
              detect-animating? $ val entry
            , merged-children

        assoc markup :coord coord :c-coord c-coord :children
          into (sorted-map)
            merge-children ({})
              , old-children new-children coord states build-mutate at-place? tick elapsed

          , :animating? animating?

      let
        (animating? $ some (fn (entry) (detect-animating? $ val entry)) (, new-children))

        assoc markup :children new-children :coord coord :c-coord c-coord :animating? animating?

defn contain-markups? (items)
  let
    (result $ some (fn (item) (if (or (= Component $ type item) (= Shape $ type item)) (, true) (if (and (map? item) (> (count item) (, 0))) (some (fn (child) (or (= Component $ type child) (= Shape $ type child))) (vals item)) (, false)))) (, items))

    -- if (not result)
      .log js/console result items
    , result

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
          markup-in-args? $ contain-markups? new-args
          new-state $ if (contains? states coord)
            get states coord
            , old-state
          on-tick $ :on-tick markup
          on-update $ :on-update markup
          update-state $ :update-state markup
          new-instant $ -> old-instant (on-tick tick elapsed)
            on-update
              into ([])
                , old-args
              into ([])
                , new-args
              , old-state new-state

          animate? $ :animate? markup
          animating? $ or (animate? new-instant)
            detect-animating? $ :tree old-tree
            :fading? markup
          cache-path $ [] coord new-args new-state new-instant
          maybe-cache $ get-cache cache-path

        -- .log js/console "|try caching" (not animating?)
          some? maybe-cache
        if
          and (not markup-in-args?)
            not animating?
            some? maybe-cache
            and (= old-args new-args)
              = old-state new-state

          do (hit-cache! cache-path)
            -- .log js/console "|user caching:" $ pr-str coord
            :data maybe-cache
          let
            (mutate $ build-mutate coord)
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

              result $ assoc old-tree :args new-args :state new-state :instant new-instant :tree new-tree

            if (not markup-in-args?)
              do (add-cache! cache-path result)
                -- .log js/console "|no cache" cache-path (:name markup)
                  some? maybe-cache
                  animate? new-instant
                  detect-animating? $ :tree old-tree
                  :tree old-tree

            -- .log js/console "|existing state" coord $ get states coord
            , result

      let
        (args $ :args markup)
          markup-in-args? $ contain-markups? args
          init-state $ :init-state markup
          init-instant $ :init-instant markup
          update-state $ :update-state markup
          state $ apply init-state args
          instant $ init-instant
            into ([])
              , args
            , state at-place?

          mutate $ build-mutate coord
          shape $ -> (:render markup)
            apply args
            apply $ list state mutate
            apply $ list instant tick
          tree $ if
            = Component $ type shape
            expand-component shape nil child-coord states build-mutate false tick elapsed
            expand-shape shape nil child-coord child-coord states build-mutate false tick elapsed
          result $ assoc markup :coord coord :args args :state state :instant instant :tree tree

        if (not markup-in-args?)
          add-cache!
            [] coord args state instant
            , result

        , result

defn expand-app
  markup old-tree states build-mutate tick elapsed
  dec-cache!
  set! js/window.componentcaches @component-caches
  -- .log js/console |caches: $ map first (map key @component-caches)
  let
    (initial-coord $ [])
    expand-component markup old-tree initial-coord states build-mutate true tick elapsed

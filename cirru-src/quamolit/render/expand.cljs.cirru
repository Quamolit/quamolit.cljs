
ns quamolit.render.expand $ :require
  [] quamolit.alias :refer $ [] Component

declare expand-component

defonce component-caches $ atom ({})

defn add-cache! (data-path data)
  swap! component-caches assoc data-path $ {} :data data :value 10

defn hit-cache! (data-path)
  .log js/console |hit data-path
  update-in component-caches (conj data-path :value)
    fn (value)
      + value 4

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
  get-in @component-caches data-path

defn detect-animating? (markup)
  if
    = Component $ type markup
    let
      (animate? $ :animate? markup)
      or
        animate? $ :instant markup
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

        into $ sorted-map

      animating? $ every?
        fn (entry)
          detect-animating? $ val entry
        , new-children

    if (some? old-tree)
      assoc markup :coord coord :c-coord c-coord :children
        into (sorted-map)
          merge-children ({})
            , old-children new-children coord states build-mutate at-place? tick elapsed

        , :animating? animating?

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
          cache-path $ [] coord new-args new-state new-instant
          maybe-cache $ get-cache cache-path

        -- .log js/console "|try caching" animating? $ some? maybe-cache
        if
          and animating? $ some? maybe-cache
          do (hit-cache! cache-path)
            , maybe-cache
          let
            (mutate $ build-mutate coord old-state update-state)
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

            -- .log js/console "|existing state" coord $ get states coord
            add-cache! cache-path result
            , result

      let
        (args $ :args markup)
          init-state $ :init-state markup
          init-instant $ :init-instant markup
          update-state $ :update-state markup
          state $ apply init-state args
          instant $ init-instant
            into ([])
              , args
            , state at-place?

          mutate $ build-mutate coord state update-state
          shape $ -> (:render markup)
            apply args
            apply $ list state mutate
            apply $ list instant tick
          tree $ if
            = Component $ type shape
            expand-component shape nil child-coord states build-mutate false tick elapsed
            expand-shape shape nil child-coord child-coord states build-mutate false tick elapsed
          result $ assoc markup :coord coord :args args :state state :instant instant :tree tree

        add-cache!
          [] coord args state instant
          , result
        , result

defn expand-app
  markup old-tree states build-mutate tick elapsed
  dec-cache!
  let
    (initial-coord $ [])
    expand-component markup old-tree initial-coord states build-mutate true tick elapsed


ns quamolit.alias

defrecord Component $ name coord args state instant init-state update-state init-instant on-tick on-update on-unmount animate? remove? render tree fading?

defrecord Shape $ name props children animating?

defn arrange-children (children)
  into (sorted-map)
    if
      and
        = (count children)
          , 1
        not $ or
          = Component $ type (first children)
          = Shape $ type (first children)

      first children
      ->> children (map-indexed vector)
        filter $ fn (entry)
          some? $ val entry

defn create-shape (shape-name props children)
  if
    not $ map? props
    throw $ js/Error. "|Props expeced to be a map!"
  ->Shape shape-name props (arrange-children children)
    , false

defn default-init-state (& args)
  {}

defn default-init-instant (args state)
  {} :numb? false

defn default-animate? (instant)
  , true

defn default-on-tick (instant tick elapsed)
  , instant

defn default-on-update
  instant old-args args old-state state
  , instant

defn default-on-unmount (instant tick)
  assoc instant :numb? true

defn default-remove? (instant)
  :numb? instant

defn create-comp
  (component-name animate? render)
    create-comp component-name nil nil nil nil nil nil animate? nil render
  (component-name init-state update-state animate? render)
    create-comp component-name init-state update-state nil nil nil nil animate? nil render
  (component-name init-instant on-tick on-update on-unmount animate? remove? render)
    create-comp component-name nil nil init-instant on-tick on-update on-unmount animate? remove? render
  (component-name init-state update-state init-instant on-tick on-update on-unmount animate? remove? render)
    fn (& args)
      Component. component-name nil args nil nil (or init-state default-init-state)
        or update-state merge
        or init-instant default-init-instant
        or on-tick default-on-tick
        or on-update default-on-update
        or on-unmount default-on-unmount
        or animate? default-animate?
        or remove? default-remove?
        , render nil false

defn line (props & children)
  create-shape :line props children

defn group (props & children)
  create-shape :group props children

defn path (props & children)
  create-shape :path props children

defn text (props & children)
  create-shape :text props children

defn arc (props & children)
  create-shape :arc props children

defn rect (props & children)
  create-shape :rect props children

defn image (props & children)
  create-shape :image props children

defn bezier (props & children)
  create-shape :bezier props children

defn native-save (props & children)
  create-shape :native-save props children

defn native-restore (props & children)
  create-shape :native-restore props children

defn native-rotate (props & children)
  create-shape :native-rotate props children

defn native-scale (props & children)
  create-shape :native-scale props children

defn native-clip (props & children)
  create-shape :native-clip props children

defn native-translate (props & children)
  create-shape :native-translate props children

defn native-transform (props & children)
  create-shape :native-transform props children

defn native-alpha (props & children)
  create-shape :native-alpha props children

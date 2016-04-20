
ns quamolit.alias

defrecord Component $ name coord args state instant render init-state update-state init-instant on-tick on-update on-unmount tree fading?

defrecord Shape $ name props children

defn create-shape
  shape-name props & children
  if
    not $ map? props
    throw $ js/Error. "|Props expeced to be a map!"
  ->Shape shape-name props $ into (sorted-map)
    if
      and
        = (count children)
          , 1
        not= Component $ type (first children)

      first children
      ->> children (map-indexed vector)
        filter $ fn (entry)
          some? $ val entry

defn default-init-state (& args)
  {}

defn default-init-instant (args state)
  {} :numb? false

defn default-on-tick (instant tick elapsed)
  , instant

defn default-on-update
  instant old-args args old-state state
  , instant

defn default-on-unmount (instant tick)
  assoc instant :numb? true

defn create-comp
  (component-name render)
    create-comp component-name nil nil nil nil nil nil render
  (component-name init-state update-state render)
    create-comp component-name init-state update-state nil nil nil nil render
  (component-name init-instant on-tick on-update on-unmount render)
    create-comp component-name nil nil init-instant on-tick on-update on-unmount render
  (component-name init-state update-state init-instant on-tick on-update on-unmount render)
    fn (& args)
      Component. component-name nil args nil ({})
        , render
        or init-state default-init-state
        or update-state merge
        or init-instant default-init-instant
        or on-tick default-on-tick
        or on-update default-on-update
        or on-unmount default-on-unmount
        , nil false

defn create-component (component-name details)
  fn (& args)
    let
      (init-state $)
        update-state $ or (:update-state details)
          , merge
        init-instant $ or (:init-instant details)
          , default-init-instant
        on-tick $ or (:on-tick details)
          , default-on-tick
        on-update $ or (:on-update details)
          , default-on-update
        on-unmount $ or (:on-unmount details)
          , default-on-unmount

      Component. component-name nil args nil ({})
        :render details
        or (:init-state details)
          , default-init-state
        or (:update-state details)
          , merge
        or (:init-instant details)
          , default-init-instant
        or (:on-tick details)
          , default-on-tick
        or (:on-update details)
          , default-on-update
        or (:on-unmount details)
          , default-on-unmount
        , nil false

def line $ partial create-shape :line

def group $ partial create-shape :group

def path $ partial create-shape :path

def circle $ partial create-shape :circle

def text $ partial create-shape :text

def arc $ partial create-shape :arc

def rect $ partial create-shape :rect

def image $ partial create-shape :image

def bezier $ partial create-shape :bezier

def native-save $ partial create-shape :native-save

def native-restore $ partial create-shape :native-restore

def native-rotate $ partial create-shape :native-rotate

def native-scale $ partial create-shape :native-scale

def native-clip $ partial create-shape :native-clip

def native-translate $ partial create-shape :native-translate

def native-transform $ partial create-shape :native-transform

def native-alpha $ partial create-shape :native-alpha

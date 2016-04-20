
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
      map-indexed vector children

defn create-component (component-name details)
  fn (& args)
    let
      (init-state $ or (:init-state details) (fn (& args) ({})))
        update-state $ or (:update-state details)
          , merge
        init-instant $ or (:init-instant details)
          fn (args state)
            {} :numb? false

        on-tick $ or (:on-tick details)
          fn (instant tick elapsed)
            , instant

        on-update $ or (:on-update details)
          fn
            instant old-args args old-state state
            , instant

        on-unmount $ or (:on-unmount details)
          fn (instant tick)
            assoc instant :numb? true

      Component. component-name nil args nil ({})
        :render details
        , init-state update-state init-instant on-tick on-update on-unmount nil false

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

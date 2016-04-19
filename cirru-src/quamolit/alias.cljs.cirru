
ns quamolit.alias

defn no-op-instant (instant & args)
  , instant

defn no-op-instant-log (instant & args)
  .log js/console "|with log" instant
  , instant

defn create-shape
  shape-name props & children
  if
    not $ map? props
    throw $ js/Error. "|Props expeced to be a map!"
  {} (:name shape-name)
    :type :shape
    :props props
    :children $ into (sorted-map)
      case (count children)
        0 $ list
        1 $ let
          (cursor $ first children)
            all-keys $ keys cursor
            all-values $ vals cursor
          if (every? number? all-keys)
            , cursor
            let
              (maybe-type $ :type cursor)
              if (keyword? maybe-type)
                [] $ [] 0 cursor
                , cursor

        map-indexed vector children

defn create-component (component-name details)
  fn (& args)
    {} (:name component-name)
      :type :component
      :args args
      :init-state $ or (:init-state details)
        fn (& args)
          {}

      :update-state $ or (:update-state details)
        , merge
      :init-instant $ or (:init-instant details)
        fn (args state)
          {} :numb? true

      :render $ :render details
      :on-unmount $ or (:on-unmount details)
        , no-op-instant
      :on-update $ or (:on-update details)
        , no-op-instant
      :on-tick $ or (:on-tick details)
        , no-op-instant

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

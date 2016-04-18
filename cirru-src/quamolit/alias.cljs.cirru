
ns quamolit.alias $ :require
  [] quamolit.util.detect :refer $ [] map-of-children?

defn no-op $

defn create-shape
  shape-name props & children
  if
    not $ map? props
    throw $ js/Error. "|Props expeced to be a map!"
  {} (:name shape-name)
    :type :shape
    :props props
    :children $ if
      and
        = 1 $ count children
        map-of-children? $ first children
      into (sorted-map)
        first children
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
        fn (& args)
          {}

      :render $ :render details
      :on-mount $ or (:on-mount details)
        , no-op
      :on-unmount $ or (:on-unmount details)
        , no-op
      :on-update $ or (:on-update details)
        , no-op
      :on-tick $ or (:on-tick details)
        , no-op

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


ns quamolit.alias

defn no-op $

defn no-op-2 ()
  , no-op-2

defn create-shape (shape-name props children)
  {} (:name shape-name)
    :type :shape
    :props props
    :children $ into (sorted-map)
      if (map? children)
        , children
        map-indexed vector children

defn create-component (component-name details)
  fn (& args)
    {} (:name component-name)
      :type :component
      :props args
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
      :on-props $ or (:on-props details)
        , no-op-2
      :on-state $ or (:on-state details)
        , no-op-2
      :on-tick $ or (:on-tick details)
        , no-op

def line $ partial create-shape :line

def group $ partial create-shape :group

def circle $ partial create-shape :circle
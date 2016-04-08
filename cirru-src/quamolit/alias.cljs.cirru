
ns quamolit.alias

defn create-shape
  tag-name props & children
  into ([])
    concat ([] tag-name props)
      , children

defn create-component (name details)
  fn (& args)
    into ([])
      concat
        [] $ assoc :details :name name
        , args

def line $ partial create-shape :line

def group $ partial create-shape :group

def circle $ partial create-shape :circle


ns quamolit.alias

defn create-element
  tag-name props & children
  concat ([] tag-name props)
    , children

def line $ partial create-element :line

def group $ partial create-element :group

def circle $ partial create-element :circle

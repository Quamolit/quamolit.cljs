
ns quamolit.component.demo $ :require
  [] quamolit.alias :refer $ [] line group circle

def demo-component $ {} (:name :demo)
  :render $ fn (props)
    fn (state)
      fn (time)
        group ({})
          line $ {}
          circle $ {}

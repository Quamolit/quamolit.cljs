
ns quamolit.component.demo $ :require
  [] quamolit.alias :refer $ [] line group circle create-component

def demo-component $ create-component :demo
  {} $ :render
    fn (props)
      fn (state)
        fn (instant alteration)
          group ({})
            line $ {}
            circle $ {}


ns quamolit.render.element $ :require
  [] quamolit.alias :refer $ [] create-component native-translate native-save native-restore group

def translate $ create-component :translate
  {} (:name translate)
    :render $ fn (props children)
      fn (state)
        fn (instant)
          group ({})
            [] (native-save $ {})
              native-translate props
              group ({})
                , children
              native-restore $ {}

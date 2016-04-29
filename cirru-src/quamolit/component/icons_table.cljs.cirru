
ns quamolit.component.icons-table $ :require
  [] quamolit.alias :refer $ [] create-comp text line group

defn render ()
  fn (state mutate)
    fn (instant)
      group ({})
        text $ {} :style
          {} (:text |icons)
            :fill-style |red

def component-icons-table $ create-comp :icons-table render

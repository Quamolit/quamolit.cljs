
ns quamolit.component.solar $ :require
  [] quamolit.alias :refer $ [] create-comp group rect

defn render ()
  fn (state mutate)
    fn (instant tick)
      rect $ {} :style ({} :fill-style |red)

def component-solar $ create-comp :solar render

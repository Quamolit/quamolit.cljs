
ns quamolit.component.solar $ :require
  [] quamolit.alias :refer $ [] create-comp group rect
  [] quamolit.render.element :refer $ [] rotate

defn render ()
  fn (state mutate)
    fn (instant tick)
      -- .log js/console :tick $ / tick 10
      rotate
        {} :style $ {} :angle
          rem (/ tick 8)
            , 360

        rect $ {} :style ({} :fill-style |red)

def component-solar $ create-comp :solar render

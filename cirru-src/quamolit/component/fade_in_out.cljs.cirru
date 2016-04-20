
ns quamolit.component.fade-in-out $ :require
  [] quamolit.alias :refer $ [] create-comp
  [] quamolit.render.element :refer $ [] alpha

defn render (props & children)
  fn (state mutate)
    fn (instant tick)
      alpha
        {} :style $ {} :opacity 0.5
        map-indexed vector children

def component-fade-in-out $ create-comp :fade-in-out render

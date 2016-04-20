
ns quamolit.component.container $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp group
  [] quamolit.render.element :refer $ [] translate
  [] quamolit.component.todolist :refer $ [] component-todolist
  [] quamolit.component.digits :refer $ [] component-digit

defn init-state ()
  , :portal

defn update-state (old-state new-page)
  , new-page

defn render (store)
  fn (state mutate)
    fn (instant)
      group
        {} $ :style ({})
        component-todolist store
        translate
          {} :style $ {} :x 340 :y -200
          component-digit 0

def container-component $ create-comp :container init-state update-state render

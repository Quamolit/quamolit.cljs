
ns quamolit.component.container $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-component group
  [] quamolit.render.element :refer $ [] translate
  [] quamolit.component.todolist :refer $ [] todolist-component
  [] quamolit.component.digits :refer $ [] component-digit

def container-component $ create-component :container
  {}
    :init-state $ fn ()
      {}
    :update-state merge
    :init-instant $ fn ()
      {}
    :render $ fn (store)
      fn (state mutate)
        fn (instant fluxion)
          group
            {} $ :style ({})
            todolist-component store
            translate
              {} :style $ {} :x 340 :y -200
              component-digit 0

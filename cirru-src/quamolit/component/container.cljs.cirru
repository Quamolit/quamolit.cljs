
ns quamolit.component.container $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-component group
  [] quamolit.render.element :refer $ [] translate
  [] quamolit.component.todolist :refer $ [] todolist-component

def container-component $ create-component :container
  {}
    :init-state $ fn ()
      {}
    :update-state merge
    :init-instant $ fn ()
      {}
    :render $ fn (store)
      fn (state)
        fn (instant fluxion)
          group
            {} $ :style ({})
            [] $ todolist-component store

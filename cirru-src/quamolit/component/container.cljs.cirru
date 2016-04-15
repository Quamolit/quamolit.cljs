
ns quamolit.component.container $ :require
  [] quamolit.alias :refer $ [] create-component group
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

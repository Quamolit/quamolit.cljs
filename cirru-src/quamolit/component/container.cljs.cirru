
ns quamolit.component.container $ :require
  [] quamolit.alias :refer $ [] create-component group
  [] quamolit.component :refer $ [] todolist-component

def container-component $ create-component :container
  {}
    :init-state $ fn ()
      {}
    :update-state merge
    :init-instant $ fn ()
      {}
    :update-instant $ fn ()
    :render $ fn (store)
      fn (state)
        fn (instant fluxion)
          group
            {} $ :style ({})
            todolist-component store

    :on-mount $ fn ()
    :on-unmount $ fn ()
    :on-update $ fn ()
    :on-tick $ fn ()

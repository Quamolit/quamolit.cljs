
ns quamolit.component.todolist $ :require
  [] quamolit.alias :refer $ [] create-component group

def todolist-component $ create-component :todolist
  {}
    :init-state $ fn ()
      {}
    :update-state merge
    :init-instant $ fn ()
      {}
    :update-instant merge
    :render $ fn (store)
      fn (state)
        fn (instant velocity)
          group $ {}

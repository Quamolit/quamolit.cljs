
ns quamolit.component.todolist $ :require
  [] quamolit.alias :refer $ [] create-component group

def todolist-component $ create-component :todolist
  {}
    :init-state $ fn ()
      {}
    :update-state merge
    :init-instant $ fn ()
      {}
    :render $ fn (store)
      fn (state)
        fn (instant)
          group $ {}


ns quamolit.core $ :require
  [] quamolit.component.container :refer $ [] container-component
  [] quamolit.render.expand :refer $ [] render-component

defonce global-store $ atom ({})

defonce global-states $ atom ({})

defonce global-tree $ atom nil

defonce global-components $ atom ({})

def render-app ()
  let
    (tree $ render-component (container-component @global-store))
      components $ pick-componets tree

    reset! global-tree tree
    reset! global-components components

defn -main ()
  enable-console-print!
  .log js/console |loaded

set! js/window.onload -main

defn on-jsload ()
  .log js/console |reloading...

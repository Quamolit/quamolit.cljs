
ns quamolit.core $ :require
  [] devtools.core :as devtools
  [] quamolit.component.container :refer $ [] container-component
  [] quamolit.render.expand :refer $ [] render-app
  [] quamolit.render.transform :refer $ [] pick-components

defonce global-store $ atom ({})

defonce global-states $ atom ({})

defonce global-instants $ atom ({})

defonce global-tree $ atom nil

defonce global-components $ atom ({})

defn render-page ()
  let
    (tree $ render-app (container-component @global-store) (, @global-states @global-instants))
      components $ pick-components tree

    reset! global-tree tree
    reset! global-components components
    .log js/console tree components

defn -main ()
  devtools/install! $ [] :custom-formatters :santy-hints
  enable-console-print!
  render-page
  .log js/console |loaded

set! js/window.onload -main

defn on-jsload ()
  .log js/console |reloading...
  render-page

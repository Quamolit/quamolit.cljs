
ns quamolit.core $ :require
  [] devtools.core :as devtools
  [] quamolit.component.container :refer $ [] container-component
  [] quamolit.render.expand :refer $ [] expand-app
  [] quamolit.render.transform :refer $ [] pick-components
  [] quamolit.util.time :refer $ [] get-tick
  [] quamolit.controller.compare :refer $ [] handle-mount handle-unmount handle-props handle-state handle-tick

defonce global-store $ atom ({})

defonce global-states $ atom ({})

defonce global-tree $ atom nil

defonce global-tick $ atom (get-tick)

defn render-page ()
  let
    (components $ expand-app (container-component @global-store) (, @global-tree @global-states))

    reset! global-components components
    .log js/console components

defn tick-page ()
  let
    (new-tick $ get-tick)
      elapse $ - new-tick @global-tick
      new-global-instants $ handle-tick @global-components @global-instants elapse
    reset! global-tick new-tick

defn -main ()
  devtools/install! $ [] :custom-formatters :santy-hints
  enable-console-print!
  render-page
  .log js/console |loaded

set! js/window.onload -main

defn on-jsload ()
  .log js/console |reloading...
  render-page


ns quamolit.core $ :require
  [] devtools.core :as devtools
  [] quamolit.component.container :refer $ [] container-component
  [] quamolit.render.expand :refer $ [] expand-app
  [] quamolit.render.transform :refer $ [] pick-components
  [] quamolit.util.time :refer $ [] get-tick
  [] quamolit.controller.compare :refer $ [] handle-mount handle-unmount handle-props handle-state handle-tick
  [] quamolit.render.flatten :refer $ [] flatten-tree
  [] quamolit.render.paint :refer $ [] paint

defonce global-store $ atom ({})

defonce global-states $ atom ({})

defonce global-tree $ atom nil

defonce global-directives $ atom ([])

defonce global-tick $ atom (get-tick)

defonce ctx $ .getContext (.querySelector js/document |#app)
  , |2d

defn render-page ()
  let
    (tree $ expand-app (container-component @global-store) (, @global-tree @global-states))
      directives $ flatten-tree tree
      target $ .querySelector js/document |#app

    reset! global-tree tree
    reset! global-directives directives
    -- .log js/console |tree tree
    -- .log js/console |directives directives
    paint ctx $ filter
      fn (directive)
        not= :group $ get directive 1
      , directives

defn tick-page ()
  let $ (new-tick $ get-tick)
    elapse $ - new-tick @global-tick

defn configure-canvas ()
  let
    (app-container $ .querySelector js/document |#app)
    .setAttribute app-container |width js/window.innerWidth
    .setAttribute app-container |height js/window.innerHeight
    render-page

defn -main ()
  devtools/install! $ [] :custom-formatters :santy-hints
  enable-console-print!
  configure-canvas
  set! window.ctx ctx
  .log js/console |loaded

set! js/window.onload -main

set! js/window.onresize configure-canvas

defn on-jsload ()
  .log js/console |reloading...
  render-page

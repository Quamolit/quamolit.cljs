
ns quamolit.core $ :require (cljs.reader :as reader)
  [] devtools.core :as devtools
  [] quamolit.component.container :refer $ [] container-component
  [] quamolit.render.expand :refer $ [] expand-app
  [] quamolit.render.transform :refer $ [] pick-components
  [] quamolit.util.time :refer $ [] get-tick
  [] quamolit.controller.compare :refer $ [] handle-mount handle-unmount handle-props handle-state handle-tick
  [] quamolit.render.flatten :refer $ [] flatten-tree
  [] quamolit.render.paint :refer $ [] paint
  [] quamolit.controller.resolve :refer $ [] resolve-target
  [] quamolit.updater.core :refer $ [] updater-fn

defonce global-store $ atom ({})

defonce global-states $ atom ({})

defonce global-tree $ atom nil

defonce global-directives $ atom ([])

defonce global-tick $ atom (get-tick)

defonce ctx $ .getContext (.querySelector js/document |#app)
  , |2d

defn dispatch (action-type action-data)
  let
    (new-tick $ get-tick)
      new-store $ updater-fn @global-store action-type action-data new-tick
    .log js/console "|store update:" new-store
    reset! global-store new-store

defn build-mutate (coord old-state update-state)
  fn (& state-args)
    let
      (partial-updater $ partial update-state old-state)
        new-state $ apply partial-updater state-args
      swap! global-states assoc coord new-state

defn render-page ()
  let
    (tree $ expand-app (container-component @global-store) (, @global-tree @global-states build-mutate))
      directives $ flatten-tree tree
      target $ .querySelector js/document |#app

    .info js/console "|rendering page..." @global-states
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

defn handle-event (event-name coord)
  let
    (maybe-listener $ resolve-target @global-tree event-name coord)
    if (some? maybe-listener)
      maybe-listener nil dispatch
      .log js/console "|no target"

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
  .addEventListener (.querySelector js/document |#app)
    , |click
    fn (event)
      let
        (hit-region $ aget event |region)
        if (some? hit-region)
          handle-event :click $ reader/read-string hit-region

  add-watch global-store :rerender render-page
  add-watch global-states :rerender render-page

set! js/window.onload -main

set! js/window.onresize configure-canvas

defn on-jsload ()
  render-page

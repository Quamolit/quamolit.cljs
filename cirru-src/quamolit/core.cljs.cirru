
ns quamolit.core $ :require (cljs.reader :as reader)
  [] devtools.core :as devtools
  [] quamolit.component.container :refer $ [] container-component
  [] quamolit.render.expand :refer $ [] expand-app
  [] quamolit.render.ticking :refer $ [] ticking-app
  [] quamolit.util.time :refer $ [] get-tick
  [] quamolit.render.flatten :refer $ [] flatten-tree
  [] quamolit.render.paint :refer $ [] paint
  [] quamolit.controller.resolve :refer $ [] resolve-target
  [] quamolit.updater.core :refer $ [] updater-fn

defonce global-store $ atom ([])

defonce global-states $ atom ({})

defonce global-tree $ atom nil

defonce global-directives $ atom ([])

defonce global-tick $ atom (get-tick)

defn dispatch (action-type action-data)
  let
    (new-tick $ get-tick)
      new-store $ updater-fn @global-store action-type action-data new-tick
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
      ctx $ .getContext target |2d

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
  let
    (new-tick $ get-tick)
      elapsed $ - new-tick @global-tick
      new-tree $ ticking-app (container-component @global-store)
        , @global-tree @global-states
      directives $ flatten-tree new-tree
      ctx $ .getContext (.querySelector js/document |#app)
        , |2d

    reset! global-tick new-tick
    reset! global-tree new-tree
    paint ctx $ filter
      fn (directive)
        not= :group $ get directive 1
      , directives

    -- .info js/console |ticking: new-tick elapsed

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
  .log js/console |loaded
  .addEventListener (.querySelector js/document |#app)
    , |click
    fn (event)
      let
        (hit-region $ aget event |region)
        .log js/console |hit: hit-region
        if (some? hit-region)
          handle-event :click $ reader/read-string hit-region

  add-watch global-store :rerender render-page
  add-watch global-states :rerender render-page

set! js/window.onload -main

set! js/window.onresize configure-canvas

defonce global-interval $ atom (js/setInterval tick-page 1000)

defn on-jsload ()
  render-page
  js/clearInterval @global-interval
  reset! global-interval $ js/setInterval tick-page 1000

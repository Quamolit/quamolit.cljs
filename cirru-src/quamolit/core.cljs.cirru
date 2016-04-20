
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
    -- .log js/console |mutate: coord old-state
    let
      (partial-updater $ partial update-state old-state)
        new-state $ apply partial-updater state-args
      swap! global-states assoc coord new-state

defn call-paint (directives)
  -- .log js/console directives @global-directives
  if (not= directives @global-directives)
    do
      let
        (target $ .querySelector js/document |#app)
          ctx $ .getContext target |2d
        paint ctx $ filter
          fn (directive)
            not= :group $ get directive 1
          , directives

      reset! global-directives directives

defn render-page ()
  let
    (new-tick $ get-tick)
      tree $ expand-app (container-component @global-store)
        , @global-tree @global-states build-mutate new-tick
      directives $ flatten-tree tree

    -- .info js/console "|rendering page..." @global-states
    reset! global-tree tree
    call-paint directives
    -- .log js/console |tree tree
    -- .log js/console |directives directives

defn tick-page ()
  let
    (new-tick $ get-tick)
      elapsed $ - new-tick @global-tick
      new-tree $ ticking-app (container-component @global-store)
        , @global-tree @global-states build-mutate new-tick elapsed
      directives $ flatten-tree new-tree

    reset! global-tick new-tick
    reset! global-tree new-tree
    -- .log js/console new-tree
    call-paint directives
    -- .info js/console |ticking: new-tick elapsed
    js/requestAnimationFrame tick-page

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
    reset! global-directives nil

defn -main ()
  devtools/install! $ [] :custom-formatters :santy-hints
  enable-console-print!
  configure-canvas
  .addEventListener (.querySelector js/document |#app)
    , |click
    fn (event)
      let
        (hit-region $ aget event |region)
        -- .log js/console |hit: hit-region
        if (some? hit-region)
          handle-event :click $ reader/read-string hit-region

  add-watch global-store :rerender render-page
  add-watch global-states :rerender render-page
  render-page
  tick-page

set! js/window.onload -main

set! js/window.onresize configure-canvas

defn on-jsload ()
  render-page

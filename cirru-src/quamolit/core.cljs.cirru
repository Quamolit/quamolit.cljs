
ns quamolit.core $ :require (cljs.reader :as reader)
  [] devtools.core :as devtools
  [] quamolit.component.container :refer $ [] container-component
  [] quamolit.render.expand :refer $ [] expand-app
  [] quamolit.util.time :refer $ [] get-tick
  [] quamolit.render.flatten :refer $ [] flatten-tree
  [] quamolit.render.paint :refer $ [] paint
  [] quamolit.controller.resolve :refer $ [] resolve-target
  [] quamolit.updater.core :refer $ [] updater-fn
  [] quamolit.controller.gc :refer $ [] states-gc

defonce global-store $ atom ([])

defonce global-states $ atom ({})

defonce global-tree $ atom nil

defonce global-directives $ atom ([])

defonce global-tick $ atom (get-tick)

defonce global-focus $ atom ([])

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
      let
        (clean-states $ states-gc @global-states @global-tree)
        reset! global-states $ assoc clean-states coord new-state

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
      elapsed $ - new-tick @global-tick
      tree $ expand-app (container-component @global-store)
        , @global-tree @global-states build-mutate new-tick elapsed
      directives $ flatten-tree tree

    -- .info js/console "|rendering page..." @global-states
    reset! global-tree tree
    reset! global-tick new-tick
    call-paint directives
    -- .log js/console |tree tree
    -- .log js/console |directives directives
    js/requestAnimationFrame render-page

defn handle-event (coord event-name event)
  let
    (maybe-listener $ resolve-target @global-tree event-name coord)
    if (some? maybe-listener)
      do (.preventDefault event)
        maybe-listener event dispatch
      -- .log js/console "|no target"

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
  let
    (root-element $ .querySelector js/document |#app)
      ctx $ .getContext root-element |2d
    .addEventListener root-element |click $ fn (event)
      let
        (hit-region $ aget event |region)
        -- .log js/console |hit: hit-region
        if (some? hit-region)
          let
            (coord $ reader/read-string hit-region)
            reset! global-focus coord
            handle-event coord :click event

          reset! global-focus $ []

    .addEventListener root-element |keypress $ fn (event)
      let
        (coord @global-focus)
        handle-event coord :keypress event

    .addEventListener root-element |keydown $ fn (event)
      let
        (coord @global-focus)
        handle-event coord :keydown event

    if
      nil? $ .-addHitRegion ctx
      js/alert "|You need to enable experimental canvas features to view this app"

  render-page

set! js/window.onload -main

set! js/window.onresize configure-canvas

defn on-jsload $

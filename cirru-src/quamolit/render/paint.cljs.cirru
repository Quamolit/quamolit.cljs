
ns quamolit.render.paint $ :require
  [] hsl.core :refer $ [] hsl

defn paint-line $ ctx props

defn paint-path $ ctx props

defn paint-rect (ctx style coord)
  let
    (x $ or (:x style) (, 0))
      y $ or (:y style)
        , 0
      w $ or (:w style)
        , 100
      h $ or (:h style)
        , 40
      line-width $ or (:line-width style)
        , 2

    .beginPath ctx
    .rect ctx x y w h
    .addHitRegion ctx $ clj->js
      {} :id $ pr-str coord
    if (contains? style :fill-style)
      do
        set! ctx.fillStyle $ :fill-style style
        .fill ctx

    if (contains? style :stroke-style)
      do
        set! ctx.strokeStyle $ :stroke-style style
        set! ctx.lineWidth line-width
        .stroke ctx

defn paint-text (ctx style)
  set! ctx.fillStyle $ or (:fill-style style)
    hsl 0 0 0
  set! ctx.textAlign $ or (:text-align style)
    , |center
  set! ctx.textBaseline $ or (:base-line style)
    , |middle
  set! ctx.font $ str
    or (:size style)
      , 20
    , "|px "
    :font-family style

  if (contains? style :fill-style)
    do $ .fillText ctx (:text style)
      or (:x style)
        , 0
      or (:y style)
        , 0
      or (:max-width style)
        , 400

  if (contains? style :stroke-style)
    do $ .strokeText ctx (:text style)
      or (:x style)
        , 0
      or (:y style)
        , 0
      or (:max-width style)
        , 400

defn paint-save (ctx style)
  .save ctx

defn paint-restore (ctx style)
  .restore ctx

defn paint-translate (ctx style)
  let
    (x $ or (:x style) (, 0))
      y $ or (:y style)
        , 0

    .translate ctx x y

defn paint-one (ctx directive)
  let
    (([] coord op props) directive)
      style $ :style props

    .log js/console :paint-one op style
    case op
      :line $ paint-line ctx style
      :path $ paint-path ctx style
      :text $ paint-text ctx style
      :rect $ paint-rect ctx style coord
      :native-save $ paint-save ctx style
      :native-restore $ paint-restore ctx style
      :native-translate $ paint-translate ctx style
      .log js/console "|painting not implemented" op

defn paint (ctx directives)
  let
    (w js/window.innerWidth) (h js/window.innerHeight)
    .clearRect ctx 0 0 1000 1000
    .save ctx
    .translate ctx (/ w 2)
      / h 2
    loop ([] ds directives)
      if
        > (count ds)
          , 0
        do
          paint-one ctx $ first ds
          recur $ rest ds

    .restore ctx

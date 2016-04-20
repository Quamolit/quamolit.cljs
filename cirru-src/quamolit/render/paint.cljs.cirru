
ns quamolit.render.paint $ :require
  [] hsl.core :refer $ [] hsl

defn paint-line (ctx style eff)
  let
    (x0 $ or (:x0 style) (, 0))
      y0 $ or (:y0 style)
        , 0
      x1 $ or (:x1 style)
        , 40
      y1 $ or (:y1 style)
        , 40
      line-width $ or (:line-width style)
        , 4
      stroke-style $ or (:stroke-style style)
        hsl 200 70 50
      line-cap $ or (:line-cap style)
        , |round
      line-join $ or (:line-join style)
        , |round
      miter-limit $ or (:miter-limit style)
        , 8

    .beginPath ctx
    .moveTo ctx x0 y0
    .lineTo ctx x1 y1
    set! ctx.lineWidth line-width
    set! ctx.strokeStyle stroke-style
    set! ctx.lineCap line-cap
    set! ctx.miterLimit miter-limit
    .stroke ctx
    , eff

def pi-ratio $ / js/Math.PI 180

defn paint-arc (ctx style eff)
  let
    (x $ or (:x style) (, 0))
      y $ or (:y style)
        , 0
      r $ or (:r style)
        , 40
      s-angle $ * pi-ratio
        or (:s-angle style)
          , 0

      e-angle $ * pi-ratio
        or (:e-angle style)
          , 60

      line-width $ or (:line-width style)
        , 4
      counterclockwise $ or (:counterclockwise style)
        , true
      line-cap $ or (:line-cap style)
        , |round
      line-join $ or (:line-join style)
        , |round
      miter-limit $ or (:miter-limit style)
        , 8

    .beginPath ctx
    .arc ctx x y r s-angle e-angle counterclockwise
    if
      some? $ :fill-style style
      do
        set! ctx.fillStyle $ :fill-style style
        .fill ctx

    if
      some? $ :stroke-style style
      do (set! ctx.lineWidth line-width)
        set! ctx.strokeStyle $ :stroke-style style
        set! ctx.lineCap line-cap
        set! ctx.miterLimit miter-limit
        .stroke ctx

    , eff

defn paint-path (ctx props eff)
  , eff

defn paint-rect
  ctx style coord eff
  let
    (w $ or (:w style) (, 100))
      h $ or (:h style)
        , 40
      x $ or (:x style)
        - 0 $ / w 2
      y $ or (:y style)
        - 0 $ / h 2
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

    , eff

defn paint-text (ctx style eff)
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

  , eff

defn paint-save (ctx style eff)
  .save ctx
  update eff :alpha-stack $ fn (alpha-stack)
    cons ctx.globalAlpha alpha-stack

defn paint-restore (ctx style eff)
  .restore ctx
  update eff :alpha-stack rest

defn paint-translate (ctx style eff)
  let
    (x $ or (:x style) (, 0))
      y $ or (:y style)
        , 0

    .translate ctx x y
    , eff

defn paint-scale (ctx style eff)
  let
    (ratio $ or (:ratio style) (, 1.2))

    .scale ctx ratio ratio
    , eff

defn paint-alpha (ctx style eff)
  let
    (inherent-opacity $ first (:alpha-stack eff))
      opacity $ * inherent-opacity
        or (:opacity style)
          , 0.5

    set! ctx.globalAlpha opacity
    update eff :alpha-stack $ fn (alpha-stack)
      cons opacity $ rest alpha-stack

defn paint-rotate (ctx style eff)
  let
    (angle $ or (:angle style) (, 30))

    .rotate ctx angle
    , eff

defn paint-one (ctx directive eff)
  let
    (([] coord op style) directive)

    -- .log js/console :paint-one op style
    case op
      :line $ paint-line ctx style eff
      :path $ paint-path ctx style eff
      :text $ paint-text ctx style eff
      :rect $ paint-rect ctx style coord eff
      :native-save $ paint-save ctx style eff
      :native-restore $ paint-restore ctx style eff
      :native-translate $ paint-translate ctx style eff
      :native-alpha $ paint-alpha ctx style eff
      :native-rotate $ paint-rotate ctx style eff
      :native-scale $ paint-scale ctx style eff
      :arc $ paint-arc ctx style eff
      do
        .log js/console "|painting not implemented" op
        , eff

defn paint (ctx directives)
  let
    (w js/window.innerWidth) (h js/window.innerHeight)
    .clearRect ctx 0 0 w h
    .save ctx
    .translate ctx (/ w 2)
      / h 2
    loop
      [] ds directives eff $ {} :alpha-stack (list 1)
      if
        > (count ds)
          , 0
        do $ recur (rest ds)
          paint-one ctx (first ds)
            , eff

    .restore ctx

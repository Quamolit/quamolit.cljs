
ns quamolit.render.paint

defn paint-line $ ctx props

defn paint-path $ ctx props

defn paint-rect (ctx style coord)
  .beginPath ctx
  .rect ctx (:x style)
    :y style
    :w style
    :h style
  .addHitRegion ctx $ clj->js
    {} :id $ pr-str coord
  if (contains? style :fill-style)
    do
      set! ctx.fillStyle $ :fill-style style
      .fill ctx

  if (contains? style :stroke-style)
    do
      set! ctx.strokeStyle $ :stroke-style style
      set! ctx.lineWidth $ :line-width style
      .stroke ctx

defn paint-text (ctx style)
  set! ctx.fillStyle $ :fill-style style
  set! ctx.textAlign $ :text-align style
  set! ctx.font $ str (:size style)
    , "|px "
    :font-family style
  if (contains? style :fill-style)
    do $ .fillText ctx (:text style)
      :x style
      :y style
      :max-width style

  if (contains? style :stroke-style)
    do $ .strokeText ctx (:text style)
      :x style
      :y style
      :max-width style

defn paint-save (ctx style)
  .save ctx

defn paint-restore (ctx style)
  .restore ctx

defn paint-translate (ctx style)
  .translate ctx (:x style)
    :y style

defn paint-one (ctx directive)
  let
    (([] coord op props) directive)
      style $ :style props

    -- .log js/console :paint-one op style
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

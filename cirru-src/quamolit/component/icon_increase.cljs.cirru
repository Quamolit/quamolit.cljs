
ns quamolit.component.icon-increase $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp line text group rect
  [] quamolit.render.element :refer $ [] translate rotate alpha
  [] quamolit.util.iterate :refer $ [] iterate-instant

defn init-state ()
  , 0

defn update-state (x)
  inc x

defn init-instant (args state)
  {} :n state :n-v 0 :n-target state

defn on-tick (instant tick elapsed)
  let
    (target $ :n-target instant)
      new-instant $ -> instant
        iterate-instant :n :n-v elapsed $ [] target target

    , new-instant

defn on-update
  instant old-args args old-state state
  if (not= old-state state)
    assoc instant :n-v 0.004 :n-target state
    , instant

defn on-unmount (instant tick)
  , instant

defn remove? (instant)
  , true

defn handle-click (mutate)
  fn (event dispatch)
    mutate

defn render ()
  fn (state mutate)
    fn (instant)
      let
        (n1 $ :n instant)
        rect
          {} :style
            {} (:w 60)
              :h 60
              :fill-style $ hsl 0 0 90
            , :event
            {} :click $ handle-click mutate

          translate
            {} :style $ {} :x -12
            rotate
              {} :style $ {} :angle (* 90 n1)
              line $ {} :style
                {}
                  :stroke-style $ hsl 0 80 30
                  :x0 -7
                  :y0 0
                  :x1 7
                  :y1 0
                  :line-width 2

              line $ {} :style
                {}
                  :stroke-style $ hsl 0 80 30
                  :x0 0
                  :y0 -7
                  :x1 0
                  :y1 7
                  :line-width 2

          translate
            {} :style $ {} (:x 10)
            into (sorted-map)
              {}
                (+ state 1)
                  translate
                    {} :style $ {} :y
                      * -20 $ - state n1
                    alpha
                      {} :style $ {} :opacity
                        - (+ 1 n1)
                          , state

                      text $ {} :style
                        {}
                          :text $ str (+ state 1)
                          :fill-style $ hsl 0 80 30
                          :font-family "|Wawati SC Regular"

                state $ translate
                  {} :style $ {} :y
                    * 20 $ - n1 (- state 1)

                  alpha
                    {} :style $ {} :opacity (- state n1)
                    text $ {} :style
                      {}
                        :text $ str state
                        :fill-style $ hsl 0 80 30
                        :font-family "|Wawati SC Regular"

def comp-icon-increase $ create-comp :icon-increase init-state update-state init-instant on-tick on-update on-unmount remove? render
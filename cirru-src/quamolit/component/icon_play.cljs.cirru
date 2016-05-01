
ns quamolit.component.icon-play $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp path group rect
  [] quamolit.util.iterate :refer $ [] iterate-instant tween
  [] quamolit.component.debug :refer $ [] comp-debug

defn init-state ()
  , true

def update-state not

defn init-instant (args state)
  let
    (value $ if true 1 0)
    {} :play-target value :play-v 0 :play-value value

defn on-tick (instant tick elapsed)
  iterate-instant instant :play-value :play-v elapsed $ [] (:play-target instant)
    :play-target instant

defn on-update
  instant old-args args old-state state
  if (= old-state state)
    , instant
    let
      (next-value $ if state 1 0)
        next-v $ if state 0.002 -0.002
      assoc instant :play-target next-value :play-v next-v

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
        (tw $ fn (a0 a1) (tween ([] a0 a1) ([] 0 1) (:play-value instant)))

        rect
          {} :style
            {} (:w 60)
              :h 60
              :fill-style $ hsl 40 80 90
            , :event
            {} :click $ handle-click mutate

          path $ {} :style
            {}
              :points $ [] ([] -20 -20)
                [] -20 20
                [] (tw -5 0)
                  tw 20 10
                [] (tw -5 0)
                  tw -20 -10

              :fill-style $ hsl 120 50 60

          path $ {} :style
            {}
              :points $ []
                [] (tw 5 0)
                  tw -20 -10
                [] 20 $ tw -20 0
                [] 20 $ tw 20 0
                [] (tw 5 0)
                  tw 20 10

              :fill-style $ hsl 120 50 60

          -- comp-debug instant $ {}

def component-icon-play $ create-comp :icon-play init-state update-state init-instant on-tick on-update on-unmount remove? render

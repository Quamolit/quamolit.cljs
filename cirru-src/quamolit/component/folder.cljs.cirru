
ns quamolit.component.folder $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp rect text group
  [] quamolit.render.element :refer $ [] translate scale alpha
  [] quamolit.util.iterate :refer $ [] iterate-instant tween

defn init-instant (args state at-place?)
  {} :presence 0 :presence-v 3 :popup 0 :popup-v 0

defn on-tick (instant tick elapsed)
  let
    (new-instant $ -> instant (iterate-instant :presence :presence-v elapsed $ [] 0 1000) (iterate-instant :popup :popup-v elapsed $ [] 0 1000))

    if
      and
        < (:presence-v instant)
          , 0
        = (:presence new-instant)
          , 0

      assoc new-instant :numb? true
      , new-instant

defn on-update
  instant old-args args old-state state
  let
    (old-popup? $ last old-args)
      popup? $ last args
    if (not= old-popup? popup?)
      assoc instant :popup-v $ if popup? 3 -3
      , instant

defn on-unmount (instant tick)
  assoc instant :presence-v -3

defn handle-back (mutate-navitate index)
  fn (event dispatch)
    mutate-navitate index

defn render
  cards position navitate index popup?
  fn (state mutate)
    fn (instant tick)
      -- .log js/console position
      let
        (shift-x $ first position)
          shift-y $ last position
          popup-ratio $ / (:popup instant)
            , 1000
          place-x $ * shift-x (- 1 popup-ratio)
          place-y $ * shift-y (- 1 popup-ratio)
          ratio $ + 0.2 (* 0.8 popup-ratio)
          bg-light $ tween ([] 60 80)
            [] 0 1
            , popup-ratio

        alpha
          {} :style $ {} :opacity
            * 0.6 $ / (:presence instant)
              , 1000

          translate
            {} :style $ {} :x place-x :y place-y
            scale
              {} :style $ {} :ratio ratio
              rect $ {} :style
                {} :w 600 :h 400 :fill-style $ hsl 0 80 bg-light
                , :event
                {} :click $ handle-back navitate index
              group ({})
                ->> cards
                  map-indexed $ fn (index card-name)
                    [] index $ let
                      (jx $ mod index 4)
                        jy $ js/Math.floor (/ index 4)
                        card-x $ * (- jx 1.5)
                          * 200 $ + 0.1 (* 0.9 popup-ratio)

                        card-y $ * (- jy 1.5)
                          * 100 $ + 0.1 (* 0.9 popup-ratio)

                      translate
                        {} $ :style
                          {} :x card-x :y card-y
                        rect
                          {} :style $ {} :w 160 :h 80 :fill-style
                            hsl 200 80 80
                          text $ {} :style ({} :text card-name)

                  into $ sorted-map

def component-folder $ create-comp :folder init-instant on-tick on-update on-unmount render

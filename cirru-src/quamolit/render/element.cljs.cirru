
ns quamolit.render.element $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-component native-translate native-alpha native-save native-restore native-rotate group rect text arrange-children

def translate $ create-component :translate
  {} $ :render
    fn (props & children)
      let
        (style $ merge ({} :x 0 :y 0) (:style props))

        fn (state)
          fn (instant)
            group ({})
              native-save $ {}
              native-translate $ assoc props :style style
              group ({})
                into ({})
                  map-indexed vector children

              native-restore $ {}

def alpha $ create-component :alpha
  {} $ :render
    fn (props & children)
      let
        (style $ merge ({} :opacity 0.5) (:style props))

        fn (state)
          fn (instant)
            group ({})
              native-save $ {}
              native-alpha $ assoc props :style style
              group ({})
                arrange-children children
              native-restore $ {}

def degree-ratio $ / js/Math.PI 180

def rotate $ create-component :rotate
  {} $ :render
    fn (props & children)
      fn (state)
        fn (instant)
          let
            (style $ :style props)
              angle $ * degree-ratio
                or (:angle style)
                  , 30

            -- .log js/console "|actual degree:" angle
            group ({})
              native-save $ {}
              native-rotate $ {} :style ({} :angle angle)
              group ({})
                arrange-children children
              native-restore $ {}

def button $ create-component :button
  {} $ :render
    fn (props)
      let
        (style $ :style props)
          guide-text $ or (:text style)
            , |button
          w $ or (:w style)
            , 100
          h $ or (:h style)
            , 40
          style-bg $ {}
            :x $ - 0 (/ w 2)
            :y $ - 0 (/ h 2)
            :fill-style $ or (:surface-color style)
              hsl 0 80 80
            :w w
            :h h

          event-button $ :event props
          style-text $ {}
            :fill-style $ or (:text-color style)
              hsl 0 0 10
            :text guide-text
            :size 20
            :font-family |Optima
            :text-align |center

        fn (state)
          fn (instant)
            group ({})
              rect $ {} :style style-bg :event event-button
              translate
                {} :style $ {} :x 0 :y 0
                text $ {} :style style-text

def input $ create-component :input
  {} $ :render
    fn (props)
      let
        (style $ :style props)
          event-collection $ :event props
          w $ :w style
          h $ :h style
          style-bg $ {}
            :fill-style $ hsl 0 50 80
            :stroke-style $ hsl 0 0 50
            :line-width 2
            :x $ - 0 (/ w 2)
            :y $ - 0 (/ h 2)
            :w w
            :h h

          style-place-text $ {}
          style-text $ {} (:text-align |center)
            :text $ :text style
            :font-family |Optima
            :size 20
            :fill-style $ hsl 0 0 0
            :x 0
            :y 0
            :max-width w

        fn (state)
          fn (instant)
            group ({})
              rect $ {} :style style-bg :event event-collection
              translate ({} :style style-place-text)
                text $ {} :style style-text

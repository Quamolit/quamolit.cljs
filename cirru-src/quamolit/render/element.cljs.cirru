
ns quamolit.render.element $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp native-translate native-alpha native-save native-restore group rect text

defn render-translate (props & children)
  let
    (style $ merge ({} :x 0 :y 0) (:style props))

    fn (state mutate)
      fn (instant)
        group ({})
          native-save $ {}
          native-translate $ assoc props :style style
          group ({})
            into ({})
              map-indexed vector children

          native-restore $ {}

def translate $ create-comp :translate render-translate

defn render-alpha (props & children)
  let
    (style $ merge ({} :opacity 0.5) (:style props))

    fn (state mutate)
      fn (instant)
        group ({})
          native-save $ {}
          native-alpha $ assoc props :style style
          group ({})
            into ({})
              map-indexed vector children

          native-restore $ {}

def alpha $ create-comp :alpha render-alpha

defn render-button (props)
  let
    (style $ :style props)
      guide-text $ or (:text style)
        , |button
      w $ or (:w style)
        , 100
      h $ or (:h style)
        , 40
      style-bg $ {} (:x 0)
        :y 0
        :fill-style $ hsl 0 80 80
        :w w
        :h h
      event-button $ :event props
      style-text $ {}
        :fill-style $ hsl 0 0 10
        :text guide-text
        :size 20
        :font-family |Optima
        :text-align |center

    fn (state mutate)
      fn (instant)
        group ({})
          rect $ {} :style style-bg :event event-button
          translate
            {} :style $ {} :x (/ w 2)
              , :y
              / h 2
            text $ {} :style style-text

def button $ create-comp :button render-button

defn render-input (props)
  let
    (style $ :style props)
      event-collection $ :event props
      w $ :w style
      h $ :h style
      style-bg $ {}
        :fill-style $ hsl 0 50 80
        :stroke-style $ hsl 0 0 50
        :line-width 2
        :x 0
        :y 0
        :w w
        :h h
      style-place-text $ {}
        :x $ / w 2
        :y $ / h 2
      style-text $ {} (:text-align |center)
        :text $ :text style
        :font-family |Optima
        :size 20
        :fill-style $ hsl 0 0 0
        :x 0
        :y 0
        :max-width w

    fn (state mutate)
      fn (instant)
        group ({})
          rect $ {} :style style-bg :event event-collection
          translate ({} :style style-place-text)
            text $ {} :style style-text

def input $ create-comp :input render-input


ns quamolit.component.binary-tree $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp line group
  [] quamolit.render.element :refer $ [] rotate scale translate

defn init-state ()
  [] (js/Math.random)
    js/Math.random
    js/Math.random
    js/Math.random

declare component-binary-tree

defn render (level)
  fn (state mutate)
    fn (instant tick)
      let
        (([] r1 r2 r3 r4) state) (x1 120)
          y1 -220
          x1-2 10
          y1-2 -80
          x2 -140
          y2 -100
          shift-a $ *
            + 0.02 $ * 0.001 r1
            js/Math.sin $ / tick
              + (* r2 100)
                , 800

          shift-b $ *
            + 0.03 $ * 0.001 r3
            js/Math.sin $ / tick
              + 1300 $ * 60 r4

        group ({})
          line $ {} :style
            {} :x1 x1 :y1 y1
          line $ {} :style
            {} :x1 x2 :y1 y2
          if (> level 0)
            translate
              {} :style $ {} :x x1 :y y1
              scale
                {} :style $ {} :ratio
                  + (* 2 shift-a)
                    , 0.5

                rotate
                  {} :style $ {} :angle
                    + (* 300 shift-a)
                      , 10

                  component-binary-tree $ dec level

          if (> level 0)
            translate
              {} :style $ {} :x x2 :y y2
              scale
                {} :style $ {} :ratio
                  + 0.83 $ * 2 shift-b
                rotate
                  {} :style $ {} :angle
                    + (* 50 shift-b)
                      , 10

                  component-binary-tree $ dec level

def component-binary-tree $ create-comp :binary-tree init-state merge render
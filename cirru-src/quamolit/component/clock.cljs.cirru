
ns quamolit.component.clock $ :require
  [] quamolit.alias :refer $ [] create-comp group
  [] quamolit.render.element :refer $ [] translate
  [] quamolit.component.digits :refer $ [] component-digit

defn render ()
  fn (state mutate)
    fn (instant)
      let
        (now $ js/Date.)
          hrs $ .getHours now
          mins $ .getMinutes now
          secs $ .getSeconds now
          get-ten $ fn (x)
            js/Math.floor $ / x 10
          get-one $ fn (x)
            mod x 10

        -- .log js/console secs
        group ({})
          -- $ translate
            {} :style $ {} :x -200
            component-digit $ get-ten hrs
          -- $ translate
            {} :style $ {} :x -140
            component-digit $ get-one hrs
          -- $ translate
            {} :style $ {} :x -60
            component-digit $ get-ten mins
          -- $ translate
            {} :style $ {} :x 0
            component-digit $ get-one mins
          -- $ translate
            {} :style $ {} :x 80
            component-digit $ get-ten secs
          translate
            {} :style $ {} :x 140
            let ()
              -- .log js/console secs
              component-digit $ get-one secs

def component-clock $ create-comp :clock render


ns quamolit.component.raining $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp rect group

defn get-tick ()
  .valueOf $ js/Date.

defn random-point ()
  []
    - (rand-int 1200)
      , 600
    - (rand-int 600)
      , 300

defn init-instant ()
  ->> (repeat 40 0)
    map $ fn (x)
      [] (get-tick)
        random-point

defn on-tick (instant tick elapsed)
  if
    > (rand-int 100)
      , 96
    assoc
      into ({})
        rest instant
      get-tick
      random-point

    , instant

defn render ()
  fn (state mutate)
    fn (instant tick)
      group ({})

def component-raining $ create-comp :raining init-instant on-tick nil nil render nil

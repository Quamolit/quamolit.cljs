
ns quamolit.component.raining $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp rect group
  [] quamolit.component.raindrop :refer $ [] component-raindrop

defn get-tick ()
  .valueOf $ js/Date.

defn random-point ()
  []
    - (rand-int 1400)
      , 600
    - (rand-int 600)
      , 500

defn init-instant ()
  let
    (init-val $ ->> (repeat 60 0) (map-indexed $ fn (index x) ([] index $ random-point)) (into $ []))

    , init-val

defn on-tick (instant tick elapsed)
  if
    > (rand-int 100)
      , 40
    conj (subvec instant 3)
      [] (get-tick)
        random-point
      [] (get-tick)
        random-point
      [] (get-tick)
        random-point

    , instant

defn on-update
  instant old-args args old-state state
  , instant

defn on-unmount (instant tick)
  , instant

defn removable? (instant)
  , true

defn render ()
  fn (state mutate)
    fn (instant tick)
      -- .log js/console $ pr-str instant
      group ({})
        ->> instant
          map $ fn (entry)
            let
              (child-key $ first entry)
                child $ last entry
              [] child-key $ component-raindrop child

          into $ sorted-map

def component-raining $ create-comp :raining init-instant on-tick on-update on-unmount render removable?

ns quamolit.component.raindrop $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp rect
  [] quamolit.render.element :refer $ [] translate alpha
  [] quamolit.util.iterate :refer $ [] iterate-instant

defn init-instant (args state at-place?)
  {} (:presence 0)
    :presence-v 3
    :begin-tick $ .valueOf (js/Date.)

defn on-tick (instant tick elapsed)
  iterate-instant instant :presence :presence-v elapsed $ [] 0 1000

defn on-update
  instant old-args args old-state state
  , instant

defn on-unmount (instant tick)
  assoc instant :presence-v -3

defn render (position)
  fn (state mutate)
    fn (instant tick)
      let
        (x $ first position)
          y $ last position
        translate
          {} $ :style
            {} :x x :y $ + y
              * 0.04 $ - tick (:begin-tick instant)

          alpha
            {} :style $ {} :opacity
              * (:presence instant)
                , 0.001

            rect $ {} :style
              {}
                :fill-style $ hsl 200 80 60
                :w 4
                :h 30

defn removable? (instant)
  and
    = 0 $ :presence instant
    = 0 $ :presence-v instant

def component-raindrop $ create-comp :raindrop init-instant on-tick on-update on-unmount render removable?

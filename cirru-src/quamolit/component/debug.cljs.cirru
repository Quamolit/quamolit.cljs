
ns quamolit.component.debug $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp rect text
  [] quamolit.render.element :refer $ [] alpha translate button

def default-style $ {} (:x 0)
  :y 0
  :fill-style $ hsl 0 0 0 0.5
  :font-family |Menlo
  :size 12
  :max-width 600

defn render (data more-style)
  fn (state mutate)
    fn (instant)
      let
        (style $ -> default-style (merge more-style) (assoc :text $ pr-str data))

        text $ {} :style style

def comp-debug $ create-comp :debug render

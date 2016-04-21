
ns quamolit.component.portal $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp group rect text
  [] quamolit.render.element :refer $ [] alpha translate button
  [] quamolit.util.iterate :refer $ [] iterate-instant tween

defn handle-navigate (mutate-navigate next-page)
  fn (event dispatch)
    mutate-navigate next-page

defn style-button (page-name bg-color)
  {} (:w 200)
    :h 80
    :surface-color bg-color
    :text page-name
    :text-color $ hsl 0 0 100

defn render (mutate-navigate)
  fn (state mutate)
    fn (instant)
      group ({})
        translate
          {} :style $ {} :x -240 :y -100
          button $ {} :style
            style-button |Todolist $ hsl 0 120 60
            , :event
            {} :click $ handle-navigate mutate-navigate :todolist

        translate
          {} :style $ {} :x -20 :y -100
          button $ {} :style
            style-button |Clock $ hsl 300 80 80
            , :event
            {} :click $ handle-navigate mutate-navigate :clock

        translate
          {} :style $ {} :x 200 :y -100
          button $ {} :style
            style-button |Solar $ hsl 140 80 80
            , :event
            {} :click $ handle-navigate mutate-navigate :solar

        translate
          {} :style $ {} :x -240 :y 20
          button $ {} :style
            style-button "|Binary Tree" $ hsl 140 20 30
            , :event
            {} :click $ handle-navigate mutate-navigate :binary-tree

        translate
          {} :style $ {} :x -20 :y 20
          button $ {} :style
            style-button |Table $ hsl 340 80 80
            , :event
            {} :click $ handle-navigate mutate-navigate :code-table

def component-portal $ create-comp :portal render


ns quamolit.component.portal $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp group rect text
  [] quamolit.render.element :refer $ [] alpha translate button
  [] quamolit.util.iterate :refer $ [] iterate-instant tween

defn handle-navigate (mutate-navigate next-page)
  fn (event dispatch)
    mutate-navigate next-page

defn style-button
  x y page-name bg-color
  {} (:w 200)
    :h 80
    :x x
    :y y
    :surface-color bg-color
    :text page-name
    :text-color $ hsl 0 0 100

defn render (mutate-navigate)
  fn (state mutate)
    fn (instant)
      group ({})
        button $ {} :style
          style-button -240 -100 |Todolist $ hsl 0 120 60
          , :event
          {} :click $ handle-navigate mutate-navigate :todolist
        button $ {} :style
          style-button -20 -100 |Clock $ hsl 300 80 80
          , :event
          {} :click $ handle-navigate mutate-navigate :clock
        button $ {} :style
          style-button 200 -100 |Solar $ hsl 140 80 80
          , :event
          {} :click $ handle-navigate mutate-navigate :solar
        button $ {} :style
          style-button -240 20 "|Binary Tree" $ hsl 140 20 30
          , :event
          {} :click $ handle-navigate mutate-navigate :binary-tree
        button $ {} :style
          style-button -20 20 |Table $ hsl 340 80 80
          , :event
          {} :click $ handle-navigate mutate-navigate :code-table
        button $ {} :style
          style-button 200 20 |Finder $ hsl 60 80 45
          , :event
          {} :click $ handle-navigate mutate-navigate :finder
        button $ {} :style
          style-button -240 140 |Raining $ hsl 260 80 80
          , :event
          {} :click $ handle-navigate mutate-navigate :raining
        button $ {} :style
          style-button -20 140 |Icons $ hsl 30 80 80
          , :event
          {} :click $ handle-navigate mutate-navigate :icons

def component-portal $ create-comp :portal render


ns quamolit.component.todolist $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-component group rect text
  [] quamolit.render.element :refer $ [] translate

defn handle-click (simple-event dispatch set-state)
  .log js/console simple-event

def todolist-component $ create-component :todolist
  {}
    :init-state $ fn ()
      {}
    :update-state merge
    :init-instant $ fn ()
      {}
    :render $ fn (store)
      fn (state)
        fn (instant)
          group ({})
            translate
              {} :style $ {} :x 0 :y -20
              group
                {} :event $ {} :click handle-click
                rect
                  {} :style
                    {}
                      :fill-style $ hsl 200 70 80
                      :stroke-style $ hsl 100 20 80
                      :line-width 2
                      :x 0
                      :y 0
                      :w 40
                      :h 40
                    , :event
                    {} :click $ fn (simple-event intent set-state)
                      .log js/console |event

                  text $ {} :style
                    {} (:size 20)
                      :font-family |Optima
                      :x 0
                      :y 0
                      :max-width 200
                      :text-align |center
                      :text |Demo
                      :fill-style $ hsl 0 80 50

            translate
              {} :style $ {} :x 0 :y -100
              group ({})
                rect
                  {} :style $ {}
                    :fill-style $ hsl 300 60 70
                    :x 0
                    :y 0
                    :w 10
                    :h 30
                  text $ {}

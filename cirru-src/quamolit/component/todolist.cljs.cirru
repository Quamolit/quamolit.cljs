
ns quamolit.component.todolist $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-component group rect text
  [] quamolit.render.element :refer $ [] translate button input

def position-header $ {} (:x 0)
  :y -100

def style-button $ {} (:w 80)
  :h 40
  :text |Demo

def style-rect $ {}
  :fill-style $ hsl 300 60 70
  :x 0
  :y 0
  :w 10
  :h 30

def position-body $ {} (:x 0)
  :y 0

def event-button $ {} :click
  fn (simple-event dispatch set-state)
    .log js/console |event

defn handle-click (simple-event dispatch set-state)
  .log js/console simple-event

defn handle-input (simple-event dispatch set-state)
  .log js/console $ js/prompt "|input to canvas:" "|default value"
  .log js/console |input

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
            translate ({} :style position-header)
              translate
                {} :style $ {} :x -100 :y 0
                input $ {} :style
                  {} :w 100 :h 40 :text |Nothing
                  , :event
                  {} :click handle-input

              translate
                {} :style $ {} :x 40
                button $ {} :style style-button :event event-button

            translate ({} :style position-body)
              group ({})
                rect ({} :style style-rect)
                  text $ {}

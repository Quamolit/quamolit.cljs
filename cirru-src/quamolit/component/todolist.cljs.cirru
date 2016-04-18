
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

defn event-button (mutate)
  {} :click $ fn (simple-event dispatch)
    .log js/console |event

defn handle-click (simple-event dispatch set-state)
  .log js/console simple-event

defn handle-input (mutate default-text)
  fn (simple-event dispatch)
    let
      (user-text $ js/prompt "|input to canvas:" default-text)
      mutate $ {} :draft user-text

def todolist-component $ create-component :todolist
  {}
    :init-state $ fn ()
      {} (:draft |)
        :show-done? false

    :update-state merge
    :init-instant $ fn ()
      {}
    :render $ fn (store)
      fn (state mutate)
        fn (instant)
          group ({})
            translate ({} :style position-header)
              translate
                {} :style $ {} :x -100 :y 0
                input $ {} :style
                  {} :w 100 :h 40 :text $ :draft state
                  , :event
                  {} :click $ handle-input mutate (:draft state)

              translate
                {} :style $ {} :x 40
                button $ {} :style style-button :event (event-button mutate)

            translate ({} :style position-body)
              group ({})
                rect ({} :style style-rect)
                  text $ {}

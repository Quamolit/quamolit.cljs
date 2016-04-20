
ns quamolit.component.todolist $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp group rect text
  [] quamolit.render.element :refer $ [] translate button input
  [] quamolit.component.task :refer $ [] component-task

def position-header $ {} (:x 0)
  :y -200

def style-button $ {} (:w 80)
  :h 40
  :text |add

def position-body $ {} (:x 0)
  :y 0

defn event-button (mutate draft)
  {} :click $ fn (simple-event dispatch)
    dispatch :add draft
    mutate $ {} :draft |

defn handle-click (simple-event dispatch set-state)
  .log js/console simple-event

defn handle-input (mutate default-text)
  fn (simple-event dispatch)
    let
      (user-text $ js/prompt "|input to canvas:" default-text)
      mutate $ {} :draft user-text

defn init-state (store)
  {} :draft |

defn render (store)
  fn (state mutate)
    fn (instant)
      -- .info js/console |todolist: store state
      group ({})
        translate ({} :style position-header)
          translate
            {} :style $ {} :x -200 :y 0
            input $ {} :style
              {} :w 400 :h 40 :text $ :draft state
              , :event
              {} :click $ handle-input mutate (:draft state)

          translate
            {} :style $ {} :x 260 :y 20
            button $ {} :style style-button :event
              event-button mutate $ :draft state

        translate ({} :style position-body)
          group ({})
            ->> store (reverse)
              map-indexed $ fn (index task)
                [] (:id task)
                  component-task task index

              into $ sorted-map

def component-todolist $ create-comp :todolist init-state merge render

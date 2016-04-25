
ns quamolit.component.todolist $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp group rect text
  [] quamolit.render.element :refer $ [] translate button input alpha
  [] quamolit.component.task :refer $ [] component-task
  [] quamolit.util.iterate :refer $ [] iterate-instant tween

def position-header $ {} (:x 0)
  :y -200

def style-button $ {} (:w 80)
  :h 40
  :text |add

def position-body $ {} (:x 0)
  :y 40

defn event-button (mutate draft)
  {} :click $ fn (simple-event dispatch)
    dispatch :add draft
    mutate $ {} :draft |

defn handle-click (simple-event dispatch set-state)
  .log js/console simple-event

def m-handle-click $ memoize handle-click

defn handle-input (mutate default-text)
  fn (simple-event dispatch)
    let
      (user-text $ js/prompt "|input to canvas:" default-text)
      mutate $ {} :draft user-text

def m-handle-input $ memoize handle-input

defn init-state (store)
  {} :draft |

defn init-instant (args state at-place?)
  {} :presence 0 :presence-v 3 :numb? false

defn on-tick (instant tick elapsed)
  let
    (new-instant $ iterate-instant instant :presence :presence-v elapsed ([] 0 1000))

    if
      and
        < (:presence-v instant)
          , 0
        = (:presence new-instant)
          , 0

      assoc new-instant :numb? true
      , new-instant

defn on-update
  instant old-args args old-state state
  , instant

defn on-unmount (instant tick)
  assoc instant :presence-v -3

defn animate? (instant)
  not= 0 $ :presence-v instant

defn render (store)
  fn (state mutate)
    fn (instant)
      .info js/console |todolist: store state
      alpha
        {} :style $ {} :opacity
          / (:presence instant)
            , 1000

        translate ({} :style position-header)
          translate
            {} :style $ {} :x -20 :y 40
            input $ {} :style
              {} :w 400 :h 40 :text $ :draft state
              , :event
              {} :click $ m-handle-input mutate (:draft state)

          translate
            {} :style $ {} :x 240 :y 40
            button $ {} :style style-button :event
              event-button mutate $ :draft state

        translate ({} :style position-body)
          group ({})
            ->> store (reverse)
              map-indexed $ fn (index task)
                let
                  (shift-x $ max -40 (min 0 $ * -40 (+ (if (> (:presence-v instant) (, 0)) (/ index $ - (count store) (, 1)) (- 1 $ if (= index 0) (, 0) (/ index $ - (count store) (, 1)))) (- 1 $ / (:presence instant) (, 500)))))

                  [] (:id task)
                    component-task task index shift-x

              into $ sorted-map

def component-todolist $ create-comp :todolist init-state merge init-instant on-tick on-update on-unmount animate? nil render

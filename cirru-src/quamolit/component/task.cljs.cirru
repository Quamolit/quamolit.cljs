
ns quamolit.component.task $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-component group rect
  [] quamolit.render.element :refer $ [] translate input

def style-block $ {} (:w 300)
  :h 40
  :fill-style $ hsl 40 80 80

defn style-done (done?)
  {} (:w 40)
    :h 40
    :fill-style $ if done?
      hsl 200 80 70
      hsl 20 80 70

defn handle-toggle (task-id)
  fn (event dispatch)
    dispatch :toggle task-id

defn handle-input (task-id task-text)
  fn (event dispatch)
    let
      (new-text $ js/prompt "|new content:" task-text)
      dispatch :update $ [] task-id new-text

defn style-input (text)
  {} (:w 400)
    :h 40
    :fill-style $ hsl 0 0 60
    :text text

def style-remove $ {} (:w 40)
  :h 40
  :fill-style $ hsl 0 80 40

defn handle-remove (task-id)
  fn (event dispatch)
    dispatch :rm task-id

defn init-instant (args state)
  {} :numb? false

defn on-mount
  instant args state at-place?
  , instant

defn on-tick (instant tick elapsed)
  , instant

defn on-update
  instant old-args args old-state state
  , instant

defn on-unmount (instant tick)
  assoc instant :numb? true

defn render (task index)
  fn (state mutate)
    fn (instant)
      .log js/console "|watch instant:" instant
      group ({})
        translate
          {} :style $ {} :x 0 :y
            - (* 60 index)
              , 140

          translate
            {} :style $ {} :x -200
            rect $ {} :style
              style-done $ :done? task
              , :event
              {} :click $ handle-toggle (:id task)

          translate
            {} :style $ {} :x -140
            input $ {} :style
              style-input $ :text task
              , :event
              {} :click $ handle-input (:id task)
                :text task

          translate
            {} :style $ {} :x 280
            rect $ {} :style style-remove :event
                  {} :click $ handle-remove (:id task)

def component-task $ create-component :task
  {} (:init-instant init-instant)
    :on-mount on-mount
    :on-tick on-tick
    :on-update on-update
    :on-unmount on-unmount
    :render render

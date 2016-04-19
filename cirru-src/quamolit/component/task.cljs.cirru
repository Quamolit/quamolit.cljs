
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
  {} (:numb? false)
    :presence 0
    :presence-velocity 0

defn on-mount
  instant args state at-place?
  assoc instant :presence-velocity 3

defn on-tick (instant tick elapsed)
  -- .log js/console "|on tick data:" tick elapsed
  let
    (v $ :presence-velocity instant)
    cond
      (= v 0) instant
      (> v 0)
        let
          (presence $ :presence instant)
            next-presence $ + presence (* v elapsed)

          if (>= next-presence 1000)
            assoc instant :presence 1000 :presence-velocity 0
            assoc instant :presence next-presence

      :else $ let
        (presence $ :presence instant)
          next-p $ + presence (* v elapsed)

        if (<= next-p 0)
          assoc instant :presence 0 :presence-velocity 0 :numb? true
          assoc instant :presence next-p

defn on-update
  instant old-args args old-state state
  , instant

defn on-unmount (instant tick)
  assoc instant :presence-velocity -3

defn render (task index)
  fn (state mutate)
    fn (instant)
      -- .log js/console "|watch instant:" $ :presence instant
      group ({})
        translate
          {} :style $ {} :x
            let
              (x $ * 0.04 (- (:presence instant) (, 1000)))

              , x

            , :y
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

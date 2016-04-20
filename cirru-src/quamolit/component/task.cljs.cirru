
ns quamolit.component.task $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp group rect
  [] quamolit.render.element :refer $ [] translate alpha input
  [] quamolit.util.iterate :refer $ [] iterate-instant
  [] quamolit.component.task-toggler :refer $ [] component-toggler

def style-block $ {} (:w 300)
  :h 40
  :fill-style $ hsl 40 80 80

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

defn init-instant (args state at-place?)
  let
    (index $ get args 1)
    {} (:numb? false)
      :presence 0
      :presence-velocity 3
      :left $ if at-place? -40 0
      :left-velocity $ if at-place? 0.09 0
      :index index
      :index-velocity 0

defn on-tick (instant tick elapsed)
  -- .log js/console "|on tick data:" instant tick elapsed
  let
    (v $ :presence-velocity instant)
      new-instant $ -> instant
        iterate-instant :presence :presence-velocity elapsed $ [] 0 1000
        iterate-instant :index :index-velocity elapsed $ repeat 2 (:index-target instant)
        iterate-instant :left :left-velocity elapsed $ [] -40 0

    if
      and (< v 0)
        = 0 $ :presence new-instant
      assoc new-instant :numb? true
      , new-instant

defn on-update
  instant old-args args old-state state
  -- .log js/console "|on update:" instant old-args args
  let
    (old-index $ get old-args 1)
      new-index $ get args 1
    if (not= old-index new-index)
      assoc instant :index-velocity
        /
          - new-index $ :index instant
          , 300
        , :index-target new-index

      , instant

defn on-unmount (instant tick)
  -- .log js/console "|calling unmount" instant
  assoc instant :presence-velocity -3 :left-velocity -0.09

defn render (task index shift-x)
  fn (state mutate)
    fn (instant)
      alpha
        {} :style $ {} :opacity
          / (:presence instant)
            , 1000

        translate
          {} :style $ {} :x
            + shift-x $ :left instant
            , :y
            -
              * 60 $ :index instant
              , 140

          translate
            {} :style $ {} :x -200
            component-toggler (:done? task)
              :id task

          translate
            {} :style $ {} :x 40
            input $ {} :style
              style-input $ :text task
              , :event
              {} :click $ handle-input (:id task)
                :text task

          translate
            {} :style $ {} :x 280
            rect $ {} :style style-remove :event
              {} :click $ handle-remove (:id task)

def component-task $ create-comp :task nil nil init-instant on-tick on-update on-unmount render


ns quamolit.component.container $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp group
  [] quamolit.render.element :refer $ [] translate button
  [] quamolit.component.todolist :refer $ [] component-todolist
  [] quamolit.component.digits :refer $ [] component-digit
  [] quamolit.component.portal :refer $ [] component-portal
  [] quamolit.component.clock :refer $ [] component-clock
  [] quamolit.component.solar :refer $ [] component-solar
  [] quamolit.component.fade-in-out :refer $ [] component-fade-in-out

defn init-state ()
  , :portal

defn update-state (old-state new-page)
  , new-page

defn style-button (guide-text)
  {} (:text guide-text)
    :surface-color $ hsl 200 80 50
    :text-color $ hsl 200 80 100
    :w 80
    :h 40

defn handle-back (mutate)
  fn (event dispatch)
    mutate :portal

defn render (store)
  fn (state mutate)
    fn (instant)
      -- .log js/console state
      group
        {} $ :style ({})
        if (= state :portal)
          component-fade-in-out ({})
            component-portal mutate

        if (not= state :portal)
          component-fade-in-out ({})
            translate
              {} :style $ {} :x -400 :y -140
              button $ {} :style (style-button |Back)
                , :event
                {} :click $ handle-back mutate

        if (= state :todolist)
          component-todolist store
        if (= state :clock)
          component-fade-in-out ({})
            translate
              {} :style $ {} :x 0 :y 0
              component-clock

        if (= state :solar)
          component-fade-in-out ({})
            translate
              {} :style $ {} :x 0 :y 0
              component-solar 8

def container-component $ create-comp :container init-state update-state render

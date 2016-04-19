
ns quamolit.component.digits $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-component rect group line
  [] quamolit.render.element :refer $ [] alpha translate
  [] quamolit.util.iterate :refer $ [] iterate-instant tween

defn init-instant (args state)
  .log js/console "|store init:" args
  let
    (style $ :style (first args))
      ([] x0 y0 x1 y1) args

    {} (:numb? false)
      :presence 0
      :presence-v 3
      :x0 x0
      :x1 x1
      :y0 y0
      :y1 y1
      :x0-v 0
      :x1-v 0
      :y0-v 0
      :y1-v 0
      :x0-target 0
      :y0-target 0
      :x1-target 0
      :y1-target 0

defn on-tick (instant tick elapsed)
  let
    (fading? $ < (:presence-v instant) (, 0))
      new-instant $ -> instant
        iterate-instant :presence :presence-v elapsed $ [] 0 1000
        iterate-instant :x0 :x0-v elapsed $ repeat 2 (:x0-target instant)
        iterate-instant :y0 :y0-v elapsed $ repeat 2 (:y0-target instant)
        iterate-instant :x1 :x1-v elapsed $ repeat 2 (:x1-target instant)
        iterate-instant :y1 :y1-v elapsed $ repeat 2 (:y1-target instant)

    if
      and fading? $ = 0 (:presence new-instant)
      assoc new-instant :numb? true
      , new-instant

defn on-update
  instant old-args args old-state state
  -- .log js/console "|stroke updaete" old-args args
  let
    (check-number $ fn (new-instant the-key the-v the-target) (let ((old-x $ get (into ([]) (, old-args)) (, the-key)) (new-x $ get (into ([]) (, args)) (, the-key))) (if (= old-x new-x) (, new-instant) (assoc new-instant the-v (/ (- new-x old-x) (, 600)) (, the-target new-x)))))

    -> instant
      check-number 0 :x0-v :x0-target
      check-number 1 :y0-v :y0-target
      check-number 2 :x1-v :x1-target
      check-number 3 :y1-v :y1-target

defn on-unmount (instant tick)
  .log js/console "|stroke unmount"
  assoc instant :presence-v -3 :numb? false

defn render
  x0 y0 x1 y1
  fn (state mutate)
    fn (instant)
      -- .log js/console |watching $ :presence instant
      group ({})
        alpha
          {} :style $ {} :opacity
            / (:presence instant)
              , 1000

          line $ {} :style
            {}
              :x0 $ :x0 instant
              :y0 $ :y0 instant
              :x1 $ :x1 instant
              :y1 $ :y1 instant

def component-stroke $ create-component :stroke
  {} (:init-instant init-instant)
    :on-update on-update
    :on-tick on-tick
    :on-unmount on-unmount
    :render render

defn render-0 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 0 0 40 0
        component-stroke 40 0 40 40
        component-stroke 40 40 40 80
        component-stroke 40 80 0 80
        component-stroke 0 80 0 40
        component-stroke 0 40 0 0

defn render-1 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 40 0 40 40
        component-stroke 40 40 40 80

defn render-2 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 0 0 40 0
        component-stroke 40 0 40 40
        component-stroke 40 40 0 40
        component-stroke 0 40 0 80
        component-stroke 0 80 40 80

defn render-3 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 0 0 40 0
        component-stroke 40 0 40 40
        component-stroke 40 40 0 40
        component-stroke 40 40 40 80
        component-stroke 40 80 0 80

defn render-4 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 0 0 0 40
        component-stroke 0 40 40 40
        component-stroke 40 40 40 0
        component-stroke 40 40 40 80

defn render-5 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 40 0 0 0
        component-stroke 0 0 0 40
        component-stroke 0 40 40 40
        component-stroke 40 40 40 80
        component-stroke 40 80 0 80

defn render-6 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 40 0 0 0
        component-stroke 0 0 0 40
        component-stroke 0 40 40 40
        component-stroke 40 40 40 80
        component-stroke 40 80 0 80
        component-stroke 0 80 0 40

defn render-7 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 0 0 40 0
        component-stroke 40 0 40 40
        component-stroke 40 40 40 80

defn render-8 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 0 0 40 0
        component-stroke 40 0 40 40
        component-stroke 40 40 40 80
        component-stroke 40 80 0 80
        component-stroke 0 80 0 40
        component-stroke 0 40 0 0
        component-stroke 0 40 40 40

defn render-9 ()
  fn (state mutate)
    fn (instant)
      group ({})
        component-stroke 40 40 0 40
        component-stroke 0 40 0 0
        component-stroke 0 0 40 0
        component-stroke 40 0 40 40
        component-stroke 40 40 40 80
        component-stroke 40 80 0 80

def component-0 $ create-component :zero
  {} $ :render render-0

def component-1 $ create-component :one
  {} $ :render render-1

def component-2 $ create-component :two
  {} $ :render render-2

def component-3 $ create-component :three
  {} $ :render render-3

def component-4 $ create-component :four
  {} $ :render render-4

def component-5 $ create-component :five
  {} $ :render render-5

def component-6 $ create-component :six
  {} $ :render render-6

def component-7 $ create-component :seven
  {} $ :render render-7

def component-8 $ create-component :eight
  {} $ :render render-8

def component-9 $ create-component :nine
  {} $ :render render-9

def style-digit-bg $ {} (:w 100)
  :h 100
  :fill-style $ hsl 0 70 90

defn init-digit-state (n)
  , 0

defn update-digit-state (x)
  js/Math.floor $ * 100 (js/Math.random)

defn handle-click (mutate)
  fn (event dispatch)
    mutate

defn pick-digit (x)
  case x (0 $ component-0)
    1 $ component-1
    2 $ component-2
    3 $ component-3
    4 $ component-4
    5 $ component-5
    6 $ component-6
    7 $ component-7
    8 $ component-8
    9 $ component-9
    component-0

defn render-digit (n)
  fn (state mutate)
    fn (instant)
      -- .log js/console :instant instant
      rect
        {} :style style-digit-bg :event $ {} :click (handle-click mutate)
        pick-digit $ js/Math.floor (/ state 10)
        translate
          {} :style $ {} :x 50
          pick-digit $ mod state 10

def component-digit $ create-component :digit
  {} (:init-state init-digit-state)
    :update-state update-digit-state
    :render render-digit

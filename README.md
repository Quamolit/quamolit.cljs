
Quamolit: a tiny animation library
----

Demo(check [browser compatibility][Browser_compatibility] first) http://repo.tiye.me/Quamolit/quamolit/

[Browser_compatibility]: https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/addHitRegion#Browser_compatibility

Features:

* declarative component markups for Canvas
* animation abstractions
* persistent data by default with ClojureScript

> Still working in progress... And Quamolit requires `ctx.addHitRegion(opts)`, which is an experimental technology.

### Usage

```bash
boot compile-cirru # generate ClojureScript at src/
boot build-simple # build app at target/
boot dev # start develop workspace at target/index.html
```

```clj
(defn init-state [arg1 arg2])
(defn update-state [old-state state-arg1 state-arg2])
(defn init-instant [args state at-place?])
(defn on-tick [instant tick elapsed])
(defn on-update [instant old-args args old-state state])
(defn on-unmount [instant tick])
(defn render [arg1 arg2]
  (fn [state mutate]
    (fn [instant tick])))
(defn removable? [instant]
  (:numb? instant))

(create-comp :demo                                                                            render)
(create-comp :demo init-state update-state                                                    render)
(create-comp :demo                         init-instant on-tick on-update on-mount removable? render)
(create-comp :demo init-state update-state init-instant on-tick on-update on-mount removable? render)

(mutate state-arg1 state-arg2)
(dispatch op op-data)
(defn updater-fn [old-store op op-data op-id])

(quamolit.util.iterate/iterate-instant instant :x :x-velovity elapsed [lower-bound upper-bound])
(quamolit.util.iterate/tween [40 60] [0 1000] 800)
```

### Paint Elements

```clj
(line {:style {
  :x0 0 :y0 0 :x1 40 :y1 40
  :line-width 4
  :stroke-style (hsl 200 870 50)
  :line-cap "round"
  :line-join "round"
  :milter-limit 8
  }})
(arc {:style {
  :x 0 :y 0:r 40
  :s-angle 0
  :e-angle 60
  :line-width 4
  :counterclockwise true
  :line-cap "round"
  :line-join "round"
  :miter-limit 8
  :fill-style nil
  :stroke-style nil
}})
(rect {:style {
  :w 100 :h 40
  :x (- (/ w 2)) :y (- (/ h 2))
  :line-width 2
}})
(text {:style {
  :fill-style (hsl 0 0 0)
  :text-align "center"
  :base-linee "middle"
  :size 20
  :font-family "Optima"
  :max-width 400
  :text ""
}})
```

### Paint Components

```clj
(translate {:style {:x 0 :y 0}})
(scale {:style {:ratio 1.2}})
(alpha {:style {:opacity 0.5}})
(rotate {:style {:angle 30}})
(button {:style {:w 100 :h 40 :text "button" :surface-color (hsl 0 80 80) :text-color (hsl 0 0 10)}})
(input {:style {:w 0 :h 0 :text ""}})
```

### License

MIT

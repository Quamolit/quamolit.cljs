
Elements
----

Each element corresponds to a Canvas API, but pretended to be an elelement. The elements are under the `quamolit.alias` namespace.

```clojure
(line {:style
        {:x0 0
         :y0 0
         :x1 40
         :y1 40
         :line-width 4
         :stroke-style (hsl 200 870 50)
         :line-cap "round"
         :line-join "round"
         :milter-limit 8}})
```

```clojure
(arc {:style
       {:x 0
        :y 0
        :r 40
        :s-angle 0
        :e-angle 60
        :line-width 4
        :counterclockwise true
        :line-cap "round"
        :line-join "round"
        :miter-limit 8
        :fill-style nil
        :stroke-style nil}})
```

```clojure
(rect {:style
        {:w 100
         :h 40
         :x (- (/ w 2))
         :y (- (/ h 2))
         :line-width 2}})
```

```clojure
(text {:style
        {:x 0
         :y 0
         :fill-style (hsl 0 0 0)
         :text-align "center"
         :base-linee "middle"
         :size 20
         :font-family "Optima"
         :max-width 400
         :text ""}})
```

```clojure
(image {:style
         {:src "lotus.jpg"
          :sx 0
          :sy 0
          :sw 40
          :sh 40
          :dx 0
          :dy 0
          :dw 40
          :dh 40}})
```

### Special APIs

Some of the Canvas APIs can not be wrapped with a simple element. So internally they are components, and components take children. The built-in components are under `quamolit.render.element` namespace.

```clojure
(translate {:style {:x 0 :y 0}})
(scale {:style {:ratio 1.2}})
(alpha {:style {:opacity 0.5}})
(rotate {:style {:angle 30}})
```

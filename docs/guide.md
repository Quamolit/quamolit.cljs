
Guide
----

### Workflow

It requires some boilerplate code to start a Quamolit project. I would suggest starting by forking my [workflow][workflow]. Although it's based on Stack Editor, the ClojureScript is the same as a normal Boot project.

[workflow]: https://github.com/Quamolit/quamolit-workflow

### Code

Or you may try copy/paste the code below and render with you own `comp-container` function. It's a Canvas renderer, so it just keeps looping and rendering. The function `render-page` will render the element tree with Canvas APIs.

```clojure
(ns quamolit.main
  (:require [quamolit.comp.container :refer [comp-container]]
            [quamolit.core :refer [render-page configure-canvas setup-events]]
            [quamolit.util.time :refer [get-tick]]
            [quamolit.updater.core :refer [updater-fn]]
            [devtools.core :as devtools]))

(defonce store-ref (atom []))

(defonce states-ref (atom {}))

(defonce loop-ref (atom nil))

(defn render-loop! [timestamp]
  (let [target (.querySelector js/document "#app")]
    (render-page (comp-container timestamp @store-ref) states-ref target)
    (reset! loop-ref (js/requestAnimationFrame render-loop!))))

(defn on-jsload []
  (js/cancelAnimationFrame @loop-ref)
  (js/requestAnimationFrame render-loop!)
  (.log js/console "code updated..."))

(defn dispatch! [op op-data]
  (let [new-tick (get-tick), new-store (updater-fn @store-ref op op-data new-tick)]
    (reset! store-ref new-store)))

(defn -main []
  (devtools/install!)
  (enable-console-print!)
  (let [target (.querySelector js/document "#app")]
    (configure-canvas target)
    (setup-events target dispatch!)
    (js/requestAnimationFrame render-loop!)))

(set! js/window.onload -main)

(set!
 js/window.onresize
 (fn [event] (let [target (.querySelector js/document "#app")] (configure-canvas target))))
```

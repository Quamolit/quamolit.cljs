
(ns quamolit.main
  (:require [quamolit.component.container :refer [container-component]]
            [quamolit.core :refer [render-page
                                   configure-canvas
                                   setup-events]]
            [quamolit.util.time :refer [get-tick]]
            [quamolit.updater.core :refer [updater-fn]]
            [devtools.core :as devtools]))

(defonce store-ref (atom []))

(defonce states-ref (atom {}))

(defonce loop-ref (atom nil))

(defn dispatch [op op-data]
  (let [new-tick (get-tick)
        new-store (updater-fn @store-ref op op-data new-tick)]
    (reset! store-ref new-store)))

(defn render-loop []
  (let [target (.querySelector js/document "#app")]
    (render-page (container-component @store-ref) states-ref target)
    (reset! loop-ref (js/requestAnimationFrame render-loop))))

(defn -main []
  (devtools/install! [:custom-formatters :santy-hints])
  (enable-console-print!)
  (let [target (.querySelector js/document "#app")]
    (configure-canvas target)
    (setup-events target dispatch)
    (render-loop)))

(set! js/window.onload -main)

(set!
  js/window.onresize
  (fn [event]
    (let [target (.querySelector js/document "#app")]
      (configure-canvas target))))

(defn on-jsload []
  (js/cancelAnimationFrame @loop-ref)
  (js/requestAnimationFrame render-loop)
  (.log js/console "code updated..."))

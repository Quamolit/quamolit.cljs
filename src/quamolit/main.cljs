
(ns quamolit.main
  (:require [quamolit.comp.container :refer [comp-container]]
            [quamolit.core :refer [render-page configure-canvas setup-events]]
            [quamolit.util.time :refer [get-tick]]
            [quamolit.updater.core :refer [updater-fn]]
            [devtools.core :as devtools]))

(defonce store-ref (atom []))

(defn dispatch! [op op-data]
  (let [new-tick (get-tick), new-store (updater-fn @store-ref op op-data new-tick)]
    (reset! store-ref new-store)))

(defonce loop-ref (atom nil))

(defonce states-ref (atom {}))

(defn render-loop! [timestamp]
  (let [target (.querySelector js/document "#app")]
    (render-page (comp-container timestamp @store-ref) states-ref target)
    (reset! loop-ref (js/requestAnimationFrame render-loop!))))

(defn -main []
  (comment devtools/install!)
  (let [target (.querySelector js/document "#app")]
    (configure-canvas target)
    (setup-events target dispatch!)
    (js/requestAnimationFrame render-loop!))
  (set!
   js/window.onresize
   (fn [event] (let [target (.querySelector js/document "#app")] (configure-canvas target)))))

(defn on-jsload []
  (js/cancelAnimationFrame @loop-ref)
  (js/requestAnimationFrame render-loop!)
  (.log js/console "code updated..."))

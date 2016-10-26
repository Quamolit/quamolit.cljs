
(ns quamolit.core
  (:require (cljs.reader :as reader)
            [quamolit.types :refer [Component]]
            [quamolit.render.expand :refer [expand-app]]
            [quamolit.util.time :refer [get-tick]]
            [quamolit.render.paint :refer [paint]]
            [quamolit.controller.resolve :refer [resolve-target locate-target]]))

(defonce tree-ref (atom nil))

(defonce tick-ref (atom (get-tick)))

(defn mutate-factory [states-ref]
  (fn [coord]
    (comment .log js/console "build new mutate" coord)
    (fn [& state-args]
      (comment .log js/console "coord:" coord)
      (comment .log js/console "states-ref" @states-ref)
      (comment .log js/console "old-state" (get @states-ref coord))
      (let [component (locate-target @tree-ref (subvec coord 0 (- (count coord) 1)))
            state-path (conj coord 'data)
            maybe-state (get-in @states-ref state-path)
            old-state (if (some? maybe-state)
                        maybe-state
                        (let [init-state (:init-state component), args (:args component)]
                          (apply init-state args)))
            update-state (:update-state component)
            new-state (apply update-state (cons old-state state-args))
            new-states (assoc-in @states-ref state-path new-state)]
        (comment .log js/console "component" component)
        (comment .log js/console "new-states" new-states)
        (reset! states-ref new-states)))))

(defonce directives-ref (atom []))

(defn call-paint [tree target]
  (comment .log js/console tree @directives-ref)
  (if (not= tree @directives-ref)
    (do
     (let [ctx (.getContext target "2d")
           eff-ref (atom {:alpha-stack (list 1)})
           w js/window.innerWidth
           h js/window.innerHeight]
       (.clearRect ctx 0 0 w h)
       (.save ctx)
       (.translate ctx (/ w 2) (/ h 2))
       (paint ctx tree eff-ref)
       (.restore ctx))
     (reset! directives-ref tree))))

(defn render-page [markup states-ref target]
  (let [new-tick (get-tick)
        elapsed (- new-tick @tick-ref)
        tree (expand-app
              markup
              @tree-ref
              @states-ref
              (mutate-factory states-ref)
              new-tick
              elapsed)]
    (comment .info js/console "rendering page..." @states-ref)
    (reset! tree-ref tree)
    (reset! tick-ref new-tick)
    (call-paint tree target)
    (comment .log js/console "tree" tree)))

(defonce focus-ref (atom []))

(defn configure-canvas [app-container]
  (.setAttribute app-container "width" js/window.innerWidth)
  (.setAttribute app-container "height" js/window.innerHeight)
  (aset (.-style app-container) "width" js/window.innerWidth)
  (aset (.-style app-container) "height" js/window.innerHeight)
  (reset! directives-ref nil))

(defn handle-event [coord event-name event dispatch]
  (let [maybe-listener (resolve-target @tree-ref event-name coord)]
    (comment .log js.console "handle event" maybe-listener coord event-name @tree-ref)
    (if (some? maybe-listener)
      (do (.preventDefault event) (maybe-listener event dispatch))
      (comment .log js/console "no target"))))

(defn setup-events [root-element dispatch]
  (let [ctx (.getContext root-element "2d")]
    (.addEventListener
     root-element
     "click"
     (fn [event]
       (let [hit-region (aget event "region")]
         (comment .log js/console "hit:" event hit-region)
         (if (some? hit-region)
           (let [coord (reader/read-string hit-region)]
             (reset! focus-ref coord)
             (handle-event coord :click event dispatch))
           (reset! focus-ref [])))))
    (.addEventListener
     root-element
     "keypress"
     (fn [event] (let [coord @focus-ref] (handle-event coord :keypress event dispatch))))
    (.addEventListener
     root-element
     "keydown"
     (fn [event] (let [coord @focus-ref] (handle-event coord :keydown event dispatch))))
    (if (nil? (aget ctx "addHitRegion"))
      (js/alert "You need to enable experimental canvas features to view this app"))))

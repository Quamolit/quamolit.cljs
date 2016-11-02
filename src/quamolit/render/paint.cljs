
(ns quamolit.render.paint
  (:require [hsl.core :refer [hsl]] [quamolit.types :refer [Component]]))

(defn paint-text [ctx style]
  (set! ctx.fillStyle (or (:fill-style style) (hsl 0 0 0)))
  (set! ctx.textAlign (or (:text-align style) "center"))
  (set! ctx.textBaseline (or (:base-line style) "middle"))
  (set! ctx.font (str (or (:size style) 20) "px " (or (:font-family style) "Optima")))
  (if (contains? style :fill-style)
    (do
     (.fillText
      ctx
      (:text style)
      (or (:x style) 0)
      (or (:y style) 0)
      (or (:max-width style) 400))))
  (if (contains? style :stroke-style)
    (do
     (.strokeText
      ctx
      (:text style)
      (or (:x style) 0)
      (or (:y style) 0)
      (or (:max-width style) 400)))))

(defn paint-restore [ctx style eff-ref]
  (.restore ctx)
  (swap! eff-ref update :alpha-stack rest))

(defn paint-alpha [ctx style eff-ref]
  (let [inherent-opacity (first (:alpha-stack @eff-ref))
        opacity (* inherent-opacity (or (:opacity style) 0.5))]
    (set! ctx.globalAlpha opacity)
    (swap! eff-ref update :alpha-stack (fn [alpha-stack] (cons opacity (rest alpha-stack))))))

(defn paint-save [ctx style eff-ref]
  (.save ctx)
  (swap! eff-ref update :alpha-stack (fn [alpha-stack] (cons ctx.globalAlpha alpha-stack))))

(def pi-ratio (/ js/Math.PI 180))

(defn paint-arc [ctx style coord]
  (let [x (or (:x style) 0)
        y (or (:y style) 0)
        r (or (:r style) 40)
        s-angle (* pi-ratio (or (:s-angle style) 0))
        e-angle (* pi-ratio (or (:e-angle style) 60))
        line-width (or (:line-width style) 4)
        counterclockwise (or (:counterclockwise style) true)
        line-cap (or (:line-cap style) "round")
        line-join (or (:line-join style) "round")
        miter-limit (or (:miter-limit style) 8)]
    (.beginPath ctx)
    (.arc ctx x y r s-angle e-angle counterclockwise)
    (let [caller (aget ctx "addHitRegion"), options (clj->js {:id (pr-str coord)})]
      (comment .log js/console "hit region" coord (some? caller))
      (if (some? caller) (.call caller ctx options)))
    (if (some? (:fill-style style))
      (do (set! ctx.fillStyle (:fill-style style)) (.fill ctx)))
    (if (some? (:stroke-style style))
      (do
       (set! ctx.lineWidth line-width)
       (set! ctx.strokeStyle (:stroke-style style))
       (set! ctx.lineCap line-cap)
       (set! ctx.miterLimit miter-limit)
       (.stroke ctx)))))

(defn paint-scale [ctx style]
  (let [ratio (or (:ratio style) 1.2)] (.scale ctx ratio ratio)))

(defn paint-translate [ctx style]
  (let [x (or (:x style) 0), y (or (:y style) 0)] (.translate ctx x y)))

(defn paint-line [ctx style]
  (let [x0 (or (:x0 style) 0)
        y0 (or (:y0 style) 0)
        x1 (or (:x1 style) 40)
        y1 (or (:y1 style) 40)
        line-width (or (:line-width style) 4)
        stroke-style (or (:stroke-style style) (hsl 200 70 50))
        line-cap (or (:line-cap style) "round")
        line-join (or (:line-join style) "round")
        miter-limit (or (:miter-limit style) 8)]
    (.beginPath ctx)
    (.moveTo ctx x0 y0)
    (.lineTo ctx x1 y1)
    (set! ctx.lineWidth line-width)
    (set! ctx.strokeStyle stroke-style)
    (set! ctx.lineCap line-cap)
    (set! ctx.miterLimit miter-limit)
    (.stroke ctx)))

(defn paint-path [ctx style]
  (let [points (:points style), first-point (first points)]
    (.beginPath ctx)
    (.moveTo ctx (first first-point) (last first-point))
    (doseq [coords (rest points)]
      (case (count coords)
        2 (.lineTo ctx (get coords 0) (get coords 1))
        4
          (.quadraticCurveTo ctx (get coords 0) (get coords 1) (get coords 2) (get coords 3))
        6
          (.bezierCurveTo
           ctx
           (get coords 0)
           (get coords 1)
           (get coords 2)
           (get coords 3)
           (get coords 4)
           (get coords 5))
        (:else (throw "not supported coords"))))
    (if (contains? style :stroke-style)
      (do
       (set! ctx.lineWidth (or (:line-width style) 4))
       (set! ctx.strokeStyle (:stroke-style style))
       (set! ctx.lineCap (or (:line-cap style) "round"))
       (set! ctx.lineJoin (or (:line-join style) "round"))
       (set! ctx.milterLimit (or (:milter-limit style) 8))
       (.stroke ctx)))
    (if (contains? style :fill-style)
      (do (set! ctx.fillStyle (:fill-style style)) (.closePath ctx) (.fill ctx)))))

(defonce image-pool (atom {}))

(defn get-image [src]
  (if (contains? image-pool src)
    (get image-pool src)
    (let [image (.createElement js/document "img")] (.setAttribute image "src" src) image)))

(defn paint-image [ctx style coord]
  (let [sx (or (:sx style) 0)
        sy (or (:sy style) 0)
        sw (or (:sw style) 40)
        sh (or (:sh style) 40)
        dx (or (:dx style) 0)
        dy (or (:dy style) 0)
        dw (or (:dw style) 40)
        dh (or (:dh style) 40)
        image (get-image (:src style))]
    (.drawImage ctx image sx sy sw sh dx dy dw dh)))

(defn paint-rect [ctx style coord]
  (let [w (or (:w style) 100)
        h (or (:h style) 40)
        x (- (or (:x style) 0) (/ w 2))
        y (- (or (:y style) 0) (/ h 2))
        line-width (or (:line-width style) 2)]
    (.beginPath ctx)
    (.rect ctx x y w h)
    (let [caller (aget ctx "addHitRegion"), options (clj->js {:id (pr-str coord)})]
      (comment .log js/console "hit region" coord (some? caller))
      (if (some? caller) (.call caller ctx options)))
    (if (contains? style :fill-style)
      (do (set! ctx.fillStyle (:fill-style style)) (.fill ctx)))
    (if (contains? style :stroke-style)
      (do
       (set! ctx.strokeStyle (:stroke-style style))
       (set! ctx.lineWidth line-width)
       (.stroke ctx)))))

(defn paint-group! [] )

(defn paint-rotate [ctx style] (let [angle (or (:angle style) 30)] (.rotate ctx angle)))

(defn paint-one [ctx directive eff-ref]
  (let [op (:name directive), style (:style directive)]
    (comment .log js/console :paint-one op style)
    (case op
      :line (paint-line ctx style)
      :path (paint-path ctx style)
      :text (paint-text ctx style)
      :rect (paint-rect ctx style (:coord directive))
      :native-save (paint-save ctx style eff-ref)
      :native-restore (paint-restore ctx style eff-ref)
      :native-translate (paint-translate ctx style)
      :native-alpha (paint-alpha ctx style eff-ref)
      :native-rotate (paint-rotate ctx style)
      :native-scale (paint-scale ctx style)
      :arc (paint-arc ctx style (:coord directive))
      :image (paint-image ctx style (:coord directive))
      :group (paint-group!)
      (do (.log js/console "painting not implemented" directive) @eff-ref))))

(defn paint [ctx tree eff-ref]
  (if (= Component (type tree))
    (recur ctx (:tree tree) eff-ref)
    (do
     (paint-one ctx tree eff-ref)
     (doseq [cursor (:children tree)] (paint ctx (last cursor) eff-ref)))))

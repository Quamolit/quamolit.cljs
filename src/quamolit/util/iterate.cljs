
(ns quamolit.util.iterate)

(defn tween [range-data range-bound x]
  (let [[a b] range-data [c d] range-bound] (+ a (/ (* (- b a) (- x c)) (- d c)))))

(defn iterate-instant [instant data-key velocity-key tick bound]
  (let [current-data (get instant data-key)
        velocity (get instant velocity-key)
        next-data (+ current-data (* tick velocity))
        lower-bound (first bound)
        upper-bound (last bound)]
    (case
      (compare velocity 0)
      -1
      (if (< next-data lower-bound)
        (assoc instant data-key lower-bound velocity-key 0)
        (assoc instant data-key next-data))
      1
      (if (> next-data upper-bound)
        (assoc instant data-key upper-bound velocity-key 0)
        (assoc instant data-key next-data))
      instant)))


(ns quamolit.util.detect )

(defn =seq [xs ys]
  (let [xs-empty? (empty? xs), ys-empty? (empty? ys)]
    (if (and xs-empty? ys-empty?)
      true
      (if (or xs-empty? ys-empty?)
        false
        (if (identical? (first xs) (first ys)) (recur (rest xs) (rest ys)) false)))))

(defn map-of-children? [x]
  (and (map? x)
       (every? (fn [entry] (and (map? (val entry)) (contains? (val entry) :type))) x)))

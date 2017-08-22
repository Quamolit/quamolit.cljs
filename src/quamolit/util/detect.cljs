
(ns quamolit.util.detect )

(defn =seq [xs ys]
  (let [xs-empty? (empty? xs), ys-empty? (empty? ys)]
    (if (and xs-empty? ys-empty?)
      true
      (if (or xs-empty? ys-empty?)
        false
        (if (identical? (first xs) (first ys)) (recur (rest xs) (rest ys)) false)))))

(defn type-as-int [x] (cond (number? x) 0 (keyword? x) 1 (string? x) 2 :else 3))

(defn compare-more [x y]
  (let [tx (type-as-int x), ty (type-as-int y)] (if (= tx ty) (compare x y) (compare tx ty))))

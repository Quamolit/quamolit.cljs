
(ns quamolit.util.detect)

(defn =vector [xs ys]
  (if (= (count xs) (count ys))
    (if (> (count xs) 0)
      (let [x0 (get xs 0) y0 (get ys 0)]
        (if (identical? x0 y0)
          (recur (subvec xs 1) (subvec ys 1))
          false))
      true)
    false))

(defn map-of-children? [x]
  (and
    (map? x)
    (every?
      (fn [entry]
        (and (map? (val entry)) (contains? (val entry) :type)))
      x)))

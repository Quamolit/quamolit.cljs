
(ns quamolit.controller.resolve
  (:require [quamolit.types :refer [Component]]
            [quamolit.util.list :refer [filter-first]]))

(defn locate-target [tree coord]
  (comment .log js/console "locating" coord tree)
  (if (= 0 (count coord))
    tree
    (let [first-pos (first coord)]
      (if (= Component (type tree))
        (if (= first-pos (:name tree))
          (recur (:tree tree) (subvec coord 1))
          nil)
        (let [picked-pair (->>
                            (:children tree)
                            (filter-first
                              (fn [child-pair]
                                (= (first child-pair) first-pos))))
              picked (if (some? picked-pair) (last picked-pair) nil)]
          (if (some? picked) (recur picked (subvec coord 1)) nil))))))

(defn resolve-target [tree event-name coord]
  (let [maybe-target (locate-target tree coord)]
    (comment .log js/console "target" maybe-target event-name coord)
    (if (nil? maybe-target)
      nil
      (let [maybe-listener (get-in
                             maybe-target
                             [:props :event event-name])]
        (comment
          .log
          js/console
          "listener"
          maybe-listener
          maybe-target)
        (if (some? maybe-listener)
          maybe-listener
          (if (= 0 (count coord))
            nil
            (recur
              tree
              event-name
              (subvec coord 0 (- (count coord) 1)))))))))

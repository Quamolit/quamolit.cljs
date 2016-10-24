
(ns quamolit.util.keyboard (:require [clojure.string :as string]))

(defn keycode->key [k shift?]
  (if (and (<= k 90) (>= k 65))
    (if shift? (js/String.fromCharCode k) (-> k js/String.fromCharCode string/lower-case))
    nil))

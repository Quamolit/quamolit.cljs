
(ns quamolit.comp.clock
  (:require [quamolit.alias :refer [create-comp group]]
            [quamolit.render.element :refer [translate]]
            [quamolit.comp.digits :refer [comp-digit]]
            [quamolit.comp.debug :refer [comp-debug]]))

(defn render [timestamp]
  (fn [state mutate instant tick]
    (let [now (js/Date.)
          hrs (.getHours now)
          mins (.getMinutes now)
          secs (.getSeconds now)
          get-ten (fn [x] (js/Math.floor (/ x 10)))
          get-one (fn [x] (mod x 10))]
      (comment .log js/console secs)
      (group
        {}
        (comp-digit (get-ten hrs) {:style {:x -200}})
        (comp-digit (get-one hrs) {:style {:x -140}})
        (comp-digit (get-ten mins) {:style {:x -60}})
        (comp-digit (get-one mins) {:style {:x 0}})
        (comp-digit (get-ten secs) {:style {:x 80}})
        (comp-digit (get-one secs) {:style {:x 140}})
        (comp-debug now {:y -60})))))

(def comp-clock (create-comp :clock render))

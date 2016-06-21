
(ns quamolit.component.code-table
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp group rect]]
            [quamolit.render.element :refer [input translate textbox]]
            [quamolit.util.keyboard :refer [keycode->key]]))

(defn init-state [] (into [] (repeat 3 (into [] (repeat 3 "")))))

(defn render [timestamp]
  (fn [state mutate]
    (fn [instant tick]
      (comment .log js/console state)
      (translate
        {:style {:y -160, :x -160}}
        (->>
          state
          (map-indexed
            (fn [i row] [i
                         (group
                           {}
                           (->>
                             row
                             (map-indexed
                               (fn 
                                 [j content]
                                 [j
                                  (let 
                                    [move-x (* i 100) move-y (* j 60)]
                                    (translate
                                      {:style {:y move-y, :x move-x}}
                                      (textbox
                                        {:style
                                         {:w 80,
                                          :h 40,
                                          :text "demo"}})))]))
                             (into (sorted-map))))]))
          (into (sorted-map)))))))

(def component-code-table
 (create-comp :code-table init-state nil render))

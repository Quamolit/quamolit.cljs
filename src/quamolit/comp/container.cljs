
(ns quamolit.comp.container
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp group]]
            [quamolit.render.element :refer [translate button]]
            [quamolit.comp.todolist :refer [comp-todolist]]
            [quamolit.comp.digits :refer [comp-digit]]
            [quamolit.comp.portal :refer [comp-portal]]
            [quamolit.comp.clock :refer [comp-clock]]
            [quamolit.comp.solar :refer [comp-solar]]
            [quamolit.comp.fade-in-out :refer [comp-fade-in-out]]
            [quamolit.comp.binary-tree :refer [comp-binary-tree]]
            [quamolit.comp.code-table :refer [comp-code-table]]
            [quamolit.comp.finder :refer [comp-finder]]
            [quamolit.comp.raining :refer [comp-raining]]
            [quamolit.comp.icons-table :refer [comp-icons-table]]
            [quamolit.comp.ring :refer [comp-ring]]
            [quamolit.comp.folding-fan :refer [comp-folding-fan]]
            [quamolit.comp.debug :refer [comp-debug]]))

(defn update-state [old-state new-page] new-page)

(defn style-button [guide-text]
  {:font-size 16,
   :surface-color (hsl 200 80 50),
   :w 80,
   :text-color (hsl 200 80 100),
   :h 32,
   :text guide-text})

(defn handle-back [mutate!] (fn [event dispatch] (mutate! :portal)))

(defn init-state [] :portal)

(defn render [timestamp store]
  (fn [state mutate! instant tick]
    (comment .log js/console state)
    (group
     {:style {}}
     (if (= state :portal) (comp-fade-in-out {} (comp-portal mutate!)))
     (if (= state :todolist) (comp-todolist timestamp store))
     (if (= state :clock)
       (comp-fade-in-out {} (translate {:style {:y 0, :x 0}} (comp-clock timestamp))))
     (if (= state :solar)
       (comp-fade-in-out {} (translate {:style {:y 0, :x 0}} (comp-solar timestamp 8))))
     (if (= state :binary-tree)
       (comp-fade-in-out
        {}
        (translate {:style {:y 240, :x 0}} (comp-binary-tree timestamp 5))))
     (if (= state :code-table)
       (comp-fade-in-out {} (translate {:style {:y 40, :x 0}} (comp-code-table))))
     (if (= state :finder)
       (comp-fade-in-out {} (translate {:style {:y 40, :x 0}} (comp-finder timestamp))))
     (if (= state :raining)
       (comp-fade-in-out {} (translate {:style {:y 40, :x 0}} (comp-raining timestamp))))
     (if (= state :icons)
       (comp-fade-in-out {} (translate {:style {:y 40, :x 0}} (comp-icons-table timestamp))))
     (if (= state :curve)
       (comp-fade-in-out {} (translate {:style {:y 40, :x 0}} (comp-ring timestamp))))
     (if (= state :folding-fan)
       (comp-fade-in-out {} (translate {:style {:y 40, :x 0}} (comp-folding-fan))))
     (if (not= state :portal)
       (comp-fade-in-out
        {}
        (translate
         {:style {:y -140, :x -400}}
         (button {:style (style-button "Back"), :event {:click (handle-back mutate!)}})))))))

(def comp-container (create-comp :container init-state update-state render))

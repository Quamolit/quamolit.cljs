
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

(defn handle-back [mutate!] (fn [event dispatch] (mutate! :portal)))

(defn init-state [] :portal)

(defn style-button [guide-text]
  {:text guide-text,
   :surface-color (hsl 200 80 50),
   :text-color (hsl 200 80 100),
   :font-size 16,
   :w 80,
   :h 32})

(defn render [timestamp store]
  (fn [state mutate! instant tick]
    (comment .log js/console state)
    (group
     {:style {}}
     (if (= state :portal) (comp-fade-in-out {} (comp-portal mutate!)))
     (if (= state :todolist) (comp-todolist timestamp store))
     (if (= state :clock)
       (comp-fade-in-out {} (translate {:style {:x 0, :y 0}} (comp-clock timestamp))))
     (if (= state :solar)
       (comp-fade-in-out {} (translate {:style {:x 0, :y 0}} (comp-solar timestamp 8))))
     (if (= state :binary-tree)
       (comp-fade-in-out
        {}
        (translate {:style {:x 0, :y 240}} (comp-binary-tree timestamp 5))))
     (if (= state :code-table)
       (comp-fade-in-out {} (translate {:style {:x 0, :y 40}} (comp-code-table))))
     (if (= state :finder)
       (comp-fade-in-out {} (translate {:style {:x 0, :y 40}} (comp-finder timestamp))))
     (if (= state :raining)
       (comp-fade-in-out {} (translate {:style {:x 0, :y 40}} (comp-raining timestamp))))
     (if (= state :icons)
       (comp-fade-in-out {} (translate {:style {:x 0, :y 40}} (comp-icons-table timestamp))))
     (if (= state :curve)
       (comp-fade-in-out {} (translate {:style {:x 0, :y 40}} (comp-ring timestamp))))
     (if (= state :folding-fan)
       (comp-fade-in-out {} (translate {:style {:x 0, :y 40}} (comp-folding-fan))))
     (if (not= state :portal)
       (comp-fade-in-out
        {}
        (translate
         {:style {:x -400, :y -140}}
         (button {:style (style-button "Back"), :event {:click (handle-back mutate!)}})))))))

(defn update-state [old-state new-page] new-page)

(def comp-container (create-comp :container init-state update-state render))


(ns quamolit.comp.container
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp group]]
            [quamolit.render.element :refer [translate button]]
            [quamolit.comp.todolist :refer [component-todolist]]
            [quamolit.comp.digits :refer [component-digit]]
            [quamolit.comp.portal :refer [component-portal]]
            [quamolit.comp.clock :refer [component-clock]]
            [quamolit.comp.solar :refer [component-solar]]
            [quamolit.comp.fade-in-out :refer [component-fade-in-out]]
            [quamolit.comp.binary-tree :refer [component-binary-tree]]
            [quamolit.comp.code-table :refer [component-code-table]]
            [quamolit.comp.finder :refer [component-finder]]
            [quamolit.comp.raining :refer [component-raining]]
            [quamolit.comp.icons-table :refer [component-icons-table]]
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

(defn handle-back [mutate] (fn [event dispatch] (mutate :portal)))

(defn init-state [] :portal)

(defn render [timestamp store]
  (fn [state mutate]
    (fn [instant tick]
      (comment .log js/console state)
      (group
        {:style {}}
        (if (= state :portal)
          (component-fade-in-out {} (component-portal mutate)))
        (if (= state :todolist) (component-todolist timestamp store))
        (if (= state :clock)
          (component-fade-in-out
            {}
            (translate
              {:style {:y 0, :x 0}}
              (component-clock timestamp))))
        (if (= state :solar)
          (component-fade-in-out
            {}
            (translate
              {:style {:y 0, :x 0}}
              (component-solar timestamp 8))))
        (if (= state :binary-tree)
          (component-fade-in-out
            {}
            (translate
              {:style {:y 240, :x 0}}
              (component-binary-tree timestamp 5))))
        (if (= state :code-table)
          (component-fade-in-out
            {}
            (translate {:style {:y 40, :x 0}} (component-code-table))))
        (if (= state :finder)
          (component-fade-in-out
            {}
            (translate
              {:style {:y 40, :x 0}}
              (component-finder timestamp))))
        (if (= state :raining)
          (component-fade-in-out
            {}
            (translate
              {:style {:y 40, :x 0}}
              (component-raining timestamp))))
        (if (= state :icons)
          (component-fade-in-out
            {}
            (translate
              {:style {:y 40, :x 0}}
              (component-icons-table timestamp))))
        (if (= state :curve)
          (component-fade-in-out
            {}
            (translate {:style {:y 40, :x 0}} (comp-ring timestamp))))
        (if (= state :folding-fan)
          (component-fade-in-out
            {}
            (translate {:style {:y 40, :x 0}} (comp-folding-fan))))
        (if (not= state :portal)
          (component-fade-in-out
            {}
            (translate
              {:style {:y -140, :x -400}}
              (button
                {:style (style-button "Back"),
                 :event {:click (handle-back mutate)}}))))))))

(def container-component
 (create-comp :container init-state update-state render))

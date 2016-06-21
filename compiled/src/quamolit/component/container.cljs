
(ns quamolit.component.container
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp group]]
            [quamolit.render.element :refer [translate button]]
            [quamolit.component.todolist :refer [component-todolist]]
            [quamolit.component.digits :refer [component-digit]]
            [quamolit.component.portal :refer [component-portal]]
            [quamolit.component.clock :refer [component-clock]]
            [quamolit.component.solar :refer [component-solar]]
            [quamolit.component.fade-in-out :refer [component-fade-in-out]]
            [quamolit.component.binary-tree :refer [component-binary-tree]]
            [quamolit.component.code-table :refer [component-code-table]]
            [quamolit.component.finder :refer [component-finder]]
            [quamolit.component.raining :refer [component-raining]]
            [quamolit.component.icons-table :refer [component-icons-table]]
            [quamolit.component.ring :refer [comp-ring]]
            [quamolit.component.folding-fan :refer [comp-folding-fan]]
            [quamolit.component.debug :refer [comp-debug]]))

(defn init-state [] :portal)

(defn update-state [old-state new-page] new-page)

(defn style-button [guide-text]
  {:font-size 16,
   :surface-color (hsl 200 80 50),
   :w 80,
   :text-color (hsl 200 80 100),
   :h 32,
   :text guide-text})

(defn handle-back [mutate] (fn [event dispatch] (mutate :portal)))

(defn render [timestamp store]
  (fn [state mutate]
    (fn [instant tick]
      (comment .log js/console state)
      (group
        {:style {}}
        (if (= state :portal)
          (component-fade-in-out {} (component-portal mutate)))
        (if (= state :todolist) (component-todolist store))
        (if (= state :clock)
          (component-fade-in-out
            {}
            (translate {:style {:y 0, :x 0}} (component-clock))))
        (if (= state :solar)
          (component-fade-in-out
            {}
            (translate {:style {:y 0, :x 0}} (component-solar 8))))
        (if (= state :binary-tree)
          (component-fade-in-out
            {}
            (translate
              {:style {:y 240, :x 0}}
              (component-binary-tree 5))))
        (if (= state :code-table)
          (component-fade-in-out
            {}
            (translate
              {:style {:y 40, :x 0}}
              (component-code-table 5))))
        (if (= state :finder)
          (component-fade-in-out
            {}
            (translate {:style {:y 40, :x 0}} (component-finder))))
        (if (= state :raining)
          (component-fade-in-out
            {}
            (translate {:style {:y 40, :x 0}} (component-raining))))
        (if (= state :icons)
          (component-fade-in-out
            {}
            (translate
              {:style {:y 40, :x 0}}
              (component-icons-table))))
        (if (= state :curve)
          (component-fade-in-out
            {}
            (translate {:style {:y 40, :x 0}} (comp-ring))))
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

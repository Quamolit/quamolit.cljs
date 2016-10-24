
(ns quamolit.comp.todolist
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp group rect text]]
            [quamolit.render.element :refer [translate button input alpha]]
            [quamolit.comp.task :refer [comp-task]]
            [quamolit.util.iterate :refer [iterate-instant tween]]
            [quamolit.comp.debug :refer [comp-debug]]))

(defn on-tick [instant tick elapsed]
  (let [new-instant (iterate-instant instant :presence :presence-v elapsed [0 1000])]
    (if (and (< (:presence-v instant) 0) (= (:presence new-instant) 0))
      (assoc new-instant :numb? true)
      new-instant)))

(defn event-button [mutate! draft]
  {:click (fn [simple-event dispatch] (dispatch :add draft) (mutate! {:draft ""}))})

(def style-button {:w 80, :h 40, :text "add"})

(defn handle-click [simple-event dispatch set-state] (.log js/console simple-event))

(def position-header {:y -200, :x 0})

(defn on-update [instant old-args args old-state state] instant)

(defn handle-input [mutate! default-text]
  (fn [simple-event dispatch]
    (let [user-text (js/prompt "input to canvas:" default-text)] (mutate! {:draft user-text}))))

(defn init-state [store] {:draft ""})

(def position-body {:y 40, :x 0})

(defn render [timestamp store]
  (fn [state mutate! instant tick]
    (comment .info js/console "todolist:" store state)
    (alpha
     {:style {:opacity (/ (:presence instant) 1000)}}
     (translate
      {:style position-header}
      (translate
       {:style {:y 40, :x -20}}
       (input
        {:style {:w 400, :h 40, :text (:draft state)},
         :event {:click (handle-input mutate! (:draft state))}}))
      (translate
       {:style {:y 40, :x 240}}
       (button {:style style-button, :event (event-button mutate! (:draft state))})))
     (translate
      {:style position-body}
      (group
       {}
       (->> store
            (reverse)
            (map-indexed
             (fn [index task]
               (let [shift-x (max
                              -40
                              (min
                               0
                               (*
                                -40
                                (+
                                 (if (= (count store) 1)
                                   0
                                   (if (> (:presence-v instant) 0)
                                     (/ index (- (count store) 1))
                                     (- 1 (if (= index 0) 0 (/ index (- (count store) 1))))))
                                 (- 1 (/ (:presence instant) 500))))))]
                 [(:id task) (comp-task timestamp task index shift-x)]))))))
     (comp-debug instant {}))))

(defn init-instant [args state at-place?] {:presence 0, :numb? false, :presence-v 3})

(defn on-unmount [instant tick] (assoc instant :presence-v -3))

(def comp-todolist
  (create-comp
   :todolist
   init-state
   merge
   init-instant
   on-tick
   on-update
   on-unmount
   nil
   render))

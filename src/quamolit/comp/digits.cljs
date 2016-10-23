
(ns quamolit.comp.digits
  (:require [hsl.core :refer [hsl]]
            [quamolit.alias :refer [create-comp rect group line]]
            [quamolit.render.element :refer [alpha translate]]
            [quamolit.util.iterate :refer [iterate-instant tween]]))

(defn on-tick [instant tick elapsed]
  (let [fading? (< (:presence-v instant) 0)
        new-instant (-> instant
                     (iterate-instant
                       :presence
                       :presence-v
                       elapsed
                       [0 1])
                     (iterate-instant
                       :x0
                       :x0-v
                       elapsed
                       (repeat 2 (:x0-target instant)))
                     (iterate-instant
                       :y0
                       :y0-v
                       elapsed
                       (repeat 2 (:y0-target instant)))
                     (iterate-instant
                       :x1
                       :x1-v
                       elapsed
                       (repeat 2 (:x1-target instant)))
                     (iterate-instant
                       :y1
                       :y1-v
                       elapsed
                       (repeat 2 (:y1-target instant))))]
    (if (and fading? (= 0 (:presence new-instant)))
      (assoc new-instant :numb? true)
      new-instant)))

(defn on-update [instant old-args args old-state state]
  (comment .log js/console "stroke updaete" old-args args)
  (let [check-number (fn [new-instant the-key the-v the-target]
                       (let [old-x (get (into [] old-args) the-key)
                             new-x (get (into [] args) the-key)]
                         (if (= old-x new-x)
                           new-instant
                           (assoc
                             new-instant
                             the-v
                             (/ (- new-x old-x) 600)
                             the-target
                             new-x))))]
    (-> instant
     (check-number 0 :x0-v :x0-target)
     (check-number 1 :y0-v :y0-target)
     (check-number 2 :x1-v :x1-target)
     (check-number 3 :y1-v :y1-target))))

(defn render [x0 y0 x1 y1]
  (fn [state mutate]
    (fn [instant]
      (comment .log js/console "watching" (:presence instant))
      (group
        {}
        (alpha
          {:style {:opacity (:presence instant)}}
          (line
            {:style
             {:y1 (:y1 instant),
              :y0 (:y0 instant),
              :x1 (:x1 instant),
              :x0 (:x0 instant)}}))))))

(defn init-instant [args state]
  (comment .log js/console "stroke init:" args)
  (let [style (:style (first args)) [x0 y0 x1 y1] args]
    {:x1-v 0,
     :x0-v 0,
     :presence 0,
     :numb? false,
     :y1 y1,
     :y0-target 0,
     :y1-target 0,
     :y0-v 0,
     :presence-v 0.003,
     :y1-v 0,
     :y0 y0,
     :x0-target 0,
     :x1 x1,
     :x0 x0,
     :x1-target 0}))

(defn on-unmount [instant tick]
  (comment .log js/console "stroke unmount")
  (assoc instant :presence-v -0.003 :numb? false))

(def component-stroke
 (create-comp
   :stroke
   init-instant
   on-tick
   on-update
   on-unmount
   nil
   render))

(defn render-3 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 0 0 40 0)
        (component-stroke 40 0 40 40)
        (component-stroke 40 40 40 80)
        (component-stroke 40 80 0 80)
        (component-stroke 40 40 0 40)))))

(defn render-7 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 0 0 40 0)
        (component-stroke 40 0 40 40)
        (component-stroke 40 40 40 80)))))

(defn render-4 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 0 0 0 40)
        (component-stroke 0 40 40 40)
        (component-stroke 40 40 40 80)
        (component-stroke 40 40 40 0)))))

(def component-4 (create-comp :four render-4))

(defn render-1 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 40 0 40 40)
        (component-stroke 40 40 40 80)))))

(def component-1 (create-comp :one render-1))

(def component-7 (create-comp :seven render-7))

(defn render-5 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 40 0 0 0)
        (component-stroke 0 0 0 40)
        (component-stroke 0 40 40 40)
        (component-stroke 40 40 40 80)
        (component-stroke 40 80 0 80)))))

(def component-5 (create-comp :five render-5))

(def component-3 (create-comp :three render-3))

(defn render-6 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 40 0 0 0)
        (component-stroke 0 0 0 40)
        (component-stroke 0 40 40 40)
        (component-stroke 40 40 40 80)
        (component-stroke 40 80 0 80)
        (component-stroke 0 80 0 40)))))

(def component-6 (create-comp :six render-6))

(defn render-8 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 0 0 40 0)
        (component-stroke 40 0 40 40)
        (component-stroke 40 40 40 80)
        (component-stroke 40 80 0 80)
        (component-stroke 0 80 0 40)
        (component-stroke 0 40 0 0)
        (component-stroke 0 40 40 40)))))

(def component-8 (create-comp :eight render-8))

(defn render-0 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 0 0 40 0)
        (component-stroke 40 0 40 40)
        (component-stroke 40 40 40 80)
        (component-stroke 40 80 0 80)
        (component-stroke 0 80 0 40)
        (component-stroke 0 40 0 0)))))

(def component-0 (create-comp :zero render-0))

(defn render-9 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 40 40 0 40)
        (component-stroke 0 40 0 0)
        (component-stroke 0 0 40 0)
        (component-stroke 40 0 40 40)
        (component-stroke 40 40 40 80)
        (component-stroke 40 80 0 80)))))

(defn render-2 [props]
  (fn [state mutate]
    (fn [instant]
      (translate
        props
        (component-stroke 0 0 40 0)
        (component-stroke 40 0 40 40)
        (component-stroke 40 40 0 40)
        (component-stroke 0 40 0 80)
        (component-stroke 0 80 40 80)))))

(def component-9 (create-comp :nine render-9))

(def component-2 (create-comp :two render-2))

(defn render-digit [n props]
  (fn [state mutate]
    (fn [instant]
      (case
        n
        0
        (component-0 props)
        1
        (component-1 props)
        2
        (component-2 props)
        3
        (component-3 props)
        4
        (component-4 props)
        5
        (component-5 props)
        6
        (component-6 props)
        7
        (component-7 props)
        8
        (component-8 props)
        9
        (component-9 props)
        (component-0 props)))))

(def component-digit (create-comp :digit render-digit))

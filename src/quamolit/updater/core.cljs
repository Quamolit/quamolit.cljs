
(ns quamolit.updater.core (:require [quamolit.schema :as schema]))

(defn task-toggle [store op-data tick]
  (->> store (mapv (fn [task] (if (= op-data (:id task)) (update task :done? not) task)))))

(defn task-add [store op-data tick] (conj store (assoc schema/task :id tick :text op-data)))

(defn task-update [store op-data tick]
  (let [[task-id text] op-data]
    (->> store (mapv (fn [task] (if (= task-id (:id task)) (assoc task :text text) task))))))

(defn task-rm [store op-data tick]
  (->> store (filterv (fn [task] (not= op-data (:id task))))))

(defn updater-fn [store op op-data tick]
  (comment .log js/console "store update:" op op-data tick)
  (case op
    :add (task-add store op-data tick)
    :rm (task-rm store op-data tick)
    :update (task-update store op-data tick)
    :toggle (task-toggle store op-data tick)
    store))

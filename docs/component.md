
Component
----

Component is defined in a record with a bunch of functions.

```clojure
(defrecord Component
  [name
   coord
   args
   states
   instant
   init-state
   update-state
   init-instant
   on-tick
   on-update
   on-unmount
   remove?
   render
   tree
   fading?])
```

In most cases you only need to define some of the functions. With Clojure you only need arity overloading:

```clojure
(create-comp :demo                                                                           render)
(create-comp :demo init-state update-state                                                   render)
(create-comp :demo                         init-instant on-tick on-update on-unmount remove? render)
(create-comp :demo init-state update-state init-instant on-tick on-update on-unmount remove? render)
```

The functions are are like:

```clojure
(defn init-state [arg1 arg2])
(defn update-state [old-state state-arg1 state-arg2])
(defn init-instant [args state at-place?])
(defn on-tick [instant tick elapsed])
(defn on-update [instant old-args args old-state state])
(defn on-unmount [instant tick])
(defn remove? [instant])
(defn render [arg1 arg2]
  (fn [state mutate instant tick]))
```

```clojure
(mutate state-arg1 state-arg2)
(dispatch op op-data)
(defn updater-fn [old-store op op-data op-id])
```

### Built Components

There are also some components defined:

```clojure
(button {:style {
  :x 0 :y 0
  :w 100 :h 40 :text "button"
  :surface-color (hsl 0 80 80) :text-color (hsl 0 0 10)
  :font-family "Optima"
  :font-size 20}})
(input {:style {:w 0 :h 0 :text ""}})
(comp-debug data {})
```

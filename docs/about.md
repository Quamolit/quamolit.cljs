
What is Quamolit?
----

> Quamolit is a declarative library for canvas animations. It's built with ClojureScript and by learning from React.

Demo http://repo.quamolit.org/quamolit/

### What's the problem?

Seeing from MVC, animations has Models too. Said by FRP(Functional Reactive Programming), the Model for animations is values changing over time, like a stream. It does have a Model, a Model for animations. But we want to program in a declarative way, which means we need that Model to be generated from our code. Meanwhile CSS animations is not we want because of the private animation states, we need global app state. So question, how to expression a time varying Model with declarative code?

### Features

* React-like components, element DSLs, event handlers, global Store
* Lifecycle functions to define animations
* Basic canvas API wrappers
* Optimization solution(basic)

### A demo

Here's a component to fade in/out. The variable `instant` represents the state for the animation. It will be updated by `on-tick`. `iterate-instant` is a function defined by Quamolit to interpolate the frames. So this component will fade in/out on mount/unmount.

```clojure
(defn init-instant [args state] {:presence 0, :numb? false, :presence-v 3})

(defn on-tick [instant tick elapsed]
  (let [new-instant (iterate-instant instant :presence :presence-v elapsed [0 1000])]
    (if (and (< (:presence-v instant) 0) (= (:presence new-instant) 0))
      (assoc new-instant :numb? true)
      new-instant)))

(defn on-update [instant old-args args old-state state] instant)

(defn on-unmount [instant tick] (assoc instant :presence-v -3))

(defn render [props & children]
  (fn [state mutate! instant tick]
    (comment .log js/console instant)
    (alpha {:style {:opacity (/ (:presence instant) 1000)}} (map-indexed vector children))))

(def comp-fade-in-out
  (create-comp :fade-in-out init-instant on-tick on-update on-unmount nil render))
```
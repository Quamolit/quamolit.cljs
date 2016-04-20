
Quamolit: a tiny animation library
----

Demo(check [browser compatibility][Browser_compatibility] first) http://repo.tiye.me/Quamolit/quamolit/

[Browser_compatibility]: https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/addHitRegion#Browser_compatibility

Features:

* declarative component markups for Canvas
* animation abstractions
* persistent data by default with ClojureScript

> Still working in progress... And Quamolit requires `ctx.addHitRegion(opts)`, which is an experimental technology.

### Usage

```bash
boot compile-cirru # generate ClojureScript at src/
boot build-simple # build app at target/
boot dev # start develop workspace at target/index.html
```

```clj
(defn init-state [arg1 arg2])
(defn update-state [old-state state-arg1 state-arg2])
(defn init-instant [args state])
(defn on-tick [instant tick elapsed])
(defn on-tick [instant tick elapsed])
(defn on-update [instant old-args args old-state state])
(defn on-unmount [instant tick])
(defn render [arg1 arg2]
  (fn [state mutate]
    (fn [instant])))

(create-comp :demo                                                                 render)
(create-comp :demo init-state update-state                                         render)
(create-comp :demo                         init-instant on-tick on-update on-mount render)
(create-comp :demo init-state update-state init-instant on-tick on-update on-mount render)

(mutate state-arg1 state-arg2)
(dispatch op op-data)
(defn updater-fn [old-store op op-data op-id])
```

### License

MIT

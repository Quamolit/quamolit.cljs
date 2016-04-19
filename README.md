
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

### License

MIT

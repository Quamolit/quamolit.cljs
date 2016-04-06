
ns quamolit.core

defn -main ()
  enable-console-print!
  .log js/console |loaded

set! js/window.onload -main

defn on-jsload ()
  .log js/console |reloading...

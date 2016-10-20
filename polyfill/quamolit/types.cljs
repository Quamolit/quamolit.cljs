
(ns quamolit.types)

(defrecord
  Component
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

(defrecord Shape [name props children])

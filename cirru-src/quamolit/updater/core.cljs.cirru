
ns quamolit.updater.core $ :require
  [] quamolit.schema :as schema

defn task-add (store op-data tick)
  conj store $ assoc schema/task :id tick :text op-data

defn task-update (store op-data tick)
  let
    (([] task-id text) op-data)

    ->> store
      map $ fn (task)
        if
          = task-id $ :id task
          assoc task :text text
          , task

      into $ []

defn task-toggle (store op-data tick)
  ->> store
    map $ fn (task)
      if
        = op-data $ :id task
        update task :done? not
        , task

    into $ []

defn task-rm (store op-data tick)
  ->> store
    filter $ fn (task)
      not= op-data $ :id task
    into $ []

defn updater-fn
  store op op-data tick
  .log js/console "|store update:" op op-data tick
  case op
    :add $ task-add store op-data tick
    :rm $ task-rm store op-data tick
    :update $ task-update store op-data tick
    :toggle $ task-toggle store op-data tick
    , store

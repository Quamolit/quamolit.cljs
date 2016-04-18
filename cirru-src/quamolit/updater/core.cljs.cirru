
ns quamolit.updater.core

defn updater-fn
  store op op-data tick
  case op (:add store)
    :rm store
    :update store
    :toggle store
    , store

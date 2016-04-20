
ns quamolit.controller.resolve $ :require
  [] quamolit.alias :refer $ [] Component

defn locate-target (tree coord)
  -- .log js/console |locating coord tree
  if
    = Component $ type tree
    recur (:tree tree)
      subvec coord 1
    if
      = coord $ :coord tree
      , tree
      if
        = 0 $ count coord
        , tree
        let
          (this-key $ first coord)
            rest-coord $ subvec coord 1
            possible-child $ get-in tree ([] :children this-key)

          if (nil? possible-child)
            , nil
            recur possible-child rest-coord

defn resolve-target (tree event-name coord)
  let
    (maybe-target $ locate-target tree coord)
    -- .log js/console |target maybe-target
    if (nil? maybe-target)
      , nil
      let
        (maybe-listener $ get-in maybe-target ([] :props :event event-name))

        -- .log js/console |listener maybe-listener
        if (some? maybe-listener)
          , maybe-listener
          if
            = 0 $ count coord
            , nil
            recur tree event-name $ subvec coord 0
              - (count coord)
                , 1

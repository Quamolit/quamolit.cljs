
ns quamolit.render.expand

declare render-component

defn render-shape
  markup coord c-coord states instants
  -> markup
    update :children $ fn (children)
      map
        fn (entry)
          let
            (markup-key $ first entry)
              markup-value $ last entry
              new-coord $ conj coord markup-key
            [] markup-key $ if
              = (:type markup-value)
                , :shape
              render-shape markup-value new-coord coord states instants
              render-component markup-value new-coord states instants

        , children

    assoc :coord coord :c-coord c-coord

defn render-component
  markup coord states instants
  let
    (props $ :props markup)
      init-state $ :init-state markup
      init-instant $ :init-instant markup
      initial-state $ apply init-state props
      initial-instant $ apply init-instant props
      renderer $ :render markup
      render-stage-0 $ apply renderer props
      render-stage-1 $ render-stage-0 initial-state
      tree $ render-stage-1 initial-instant
    {}
      :name $ :name markup
      :type :component
      :props props
      :update-state $ :update-state markup
      :update-instant $ :update-instant markup
      :shape $ render-shape tree coord coord states instants
      :coord coord

defn render-app (markup states instants)
  render-component markup ([] 0)
    , states instants

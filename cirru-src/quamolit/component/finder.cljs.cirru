
ns quamolit.component.finder $ :require
  [] hsl.core :refer $ [] hsl
  [] quamolit.alias :refer $ [] create-comp rect group
  [] quamolit.component.folder :refer $ [] component-folder

def card-collection $ []
  [] |喷雪花 |檵木 |石楠 |文竹
  [] |紫云英 |绣球花 |蔷薇
  [] |金银花 |栗树 |婆婆纳 |鸡爪槭
  [] |卷柏 |稻 |马尾松 |五角星花 |苔藓
  [] |芍药 |木棉

defn init-state ()
  [] card-collection nil

defn update-state (state target)
  -- .log js/console state target
  assoc state 1 target

defn handle-back (mutate)
  fn (event dispatch)
    mutate nil

defn render ()
  fn (state mutate)
    fn (instant tick)
      -- .log js/console instant state
      rect
        {} :style
          {} :w 1000 :h 600 :fill-style $ hsl 100 40 90
          , :event
          {} :click $ handle-back mutate
        group ({})
          ->> (first state)
            map-indexed $ fn (index folder)
              -- .log js/console folder
              let
                (ix $ mod index 4)
                  iy $ js/Math.floor (/ index 4)
                  position $ []
                    - (* ix 200)
                      , 200
                    - (* iy 200)
                      , 100

                [] index $ component-folder folder position mutate index
                  = index $ last state

            filter $ fn (entry)
              let
                (([] index tree) entry)
                  target $ last state

                if (some? target)
                  = index target
                  , true

            into $ sorted-map

def component-finder $ create-comp :finder init-state update-state render


ns quamolit.component.icons-table $ :require
  [] quamolit.alias :refer $ [] create-comp text line group
  [] quamolit.component.icon-increase :refer $ [] comp-icon-increase

defn render ()
  fn (state mutate)
    fn (instant)
      group ({})
        comp-icon-increase

def component-icons-table $ create-comp :icons-table render

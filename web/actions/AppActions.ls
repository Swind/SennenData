require! {
  "lokijs": lokijs
  "../../sennen.json": RawData
}

RESET_MELEE_CHARS = "RESET_MELEE_CHARS"
ADD_MELEE_CHARS = "ADD_MELEE_CHARS"
REMOVE_MELEE_CHARS = "REMOVE_MELEE_CHARS"

RESET_RANGE_CHARS = "RESET_RANGE_CHARS"
ADD_RANGE_CHARS = "ADD_RANGE_CHARS"
REMOVE_RANGE_CHARS = "REMOVE_RANGE_CHARS"
/*====================================================================
*
*   Init Database
*
=====================================================================*/
db = new lokijs \db
char_db = db.addCollection \char_db

for char in RawData
  char_db.insert char

/*====================================================================
*
*   Actions 
*
=====================================================================*/
reset_filter = (action_type, char_type, no_use=null) -->
  return {
    type: action_type
    char_list: char_db.find {type: char_type}
  }

update_filter = (action_type, char_type, removed, filter_map) -->

  filter_list = []
  for filter, enable in filter_map
    if filter !== removed
      filter_list[*] = filter

  return {
    type: action_type
    char_list: char_db.find {
      type: char_type
      class_type: {
        $in: filter_list
      }
    }
  }

add_melee_filter = update_filter ADD_MELEE_CHARS, \melee, false
add_range_filter = update_filter ADD_RANGE_CHARS, \range, false

remove_melee_filter = update_filter REMOVE_MELEE_CHARS, \melee, true
remove_range_filter = update_filter REMOVE_RANGE_CHARS, \range, true

reset_melee_filter = reset_filter RESET_MELEE_CHARS, \melee
reset_range_filter = reset_filter RESET_RANGE_CHARS, \range

module.exports = {
  RESET_MELEE_CHARS
  ADD_MELEE_CHARS
  REMOVE_MELEE_CHARS

  RESET_RANGE_CHARS
  ADD_RANGE_CHARS
  REMOVE_RANGE_CHARS

  add_melee_filter
  add_range_filter

  remove_melee_filter
  remove_range_filter

  reset_melee_filter
  reset_range_filter
}

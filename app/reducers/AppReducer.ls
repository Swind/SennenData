require! {
  "redux": {combineReducers, createStore} 
  "../actions/AppActions": Actions
}

classify = (new_char_list) ->
  class_map = {}

  for char in new_char_list
    if not class_map[char.class_type]
      class_map[char.class_type] = []

    class_map[char.class_type][*] = char

  return class_map

/*============================================================================
*
*   Filters
*
*============================================================================*/

create_filters = (ADD_CASE_CASE, REMOVE_CASE_CASE, RESET_CASE_CASE, 
                  state = {char_list:[], class_map:{}, class_types:[]}, 
                  action) -->

  switch action.type
  case RESET_CASE_CASE
    new_class_map = classify action.char_list

    class_types_map = {}
    for class_type, char_list of new_class_map
      class_types_map[class_type] = true

    return {
      class_map: new_class_map
      char_list: action.char_list
      class_types_map: class_types_map
    }

  case ADD_CASE_CASE
    new_class_map = classify action.char_list

    class_types_map = {}
    for class_type, char_list of new_class_map
      class_types_map[class_type] = true

    return {
      class_map: state.class_map
      char_list: state.char_list
      class_types_map: {} <<< state.class_types_map <<< class_types_map
    }

  case REMOVE_CASE_CASE

    new_char_list = state.char_list.filter (item) ->
      for removed_char in action.char_list
        if removed_char === item
          return false 
      return true 

    new_class_map = classify new_char_list

    class_types_map = {} <<< state.class_types_map
    for char in action.char_list
      class_types_map[char.class_type] = false

    return {
      class_map: state.class_map 
      char_list: state.char_list 
      class_types_map: class_types_map
    }

  default
    return state

melee_chars = create_filters(Actions.ADD_MELEE_CHARS)(Actions.REMOVE_MELEE_CHARS)(Actions.RESET_MELEE_CHARS)
range_chars = create_filters(Actions.ADD_RANGE_CHARS)(Actions.REMOVE_RANGE_CHARS)(Actions.RESET_RANGE_CHARS)

const sennenData = combineReducers {
  melee_chars
  range_chars
}

module.exports = createStore sennenData

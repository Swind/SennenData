require! {
  "redux": {combineReducers} 
  "../actions/AppActions": Actions
}

classify = (new_char_list) ->
  class_map = {}

  for char in new_char_list
    if not class_map[char.class_type]
      class_map[char.class_type] = []

    class_map[char.class_type][*] = char

  return class_map


create_filters = (ADD_CASE_CASE, REMOVE_CASE_CASE, RESET_CASE_CASE, state = {char_list:[], class_map:{}}, action) -->

  switch action.type
  case RESET_CASE_CASE
    new_class_map = classify action.char_list

    return {
      class_map: new_class_map
      char_list: action.char_list
    }

  case ADD_CASE_CASE
    new_class_map = classify action.char_list

    return {
      class_map: {} <<< state.class_map <<< new_class_map
      char_list: state.class_list.concat action.char_list
    }

  case REMOVE_CASE_CASE
    new_char_list = state.char_list.filter (item) ->
      for removed_char in action.char_list
        if removed_char === item
          return true
      return false

    new_class_map = classify new_char_list

    return {
      class_map: new_class_map
      char_list: new_char_list
    }

  default
    return state

melee_chars = create_filters(Actions.ADD_MELEE_CHARS)(Actions.REMOVE_MELEE_CHARS)(Actions.RESET_MELEE_CHARS)
range_chars = create_filters(Actions.ADD_RANGE_CHARS)(Actions.REMOVE_RANGE_CHARS)(Actions.RESET_RANGE_CHARS)


const sennenData = combineReducers {
  melee_chars
  range_chars
}

module.exports = sennenData

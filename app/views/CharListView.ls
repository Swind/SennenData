require! {
  "../react-wrapper": {Component}
}

mdl-table-style = "mdl-data-table mdl-js-data-table"

/*===================================================
*
*   Class Char detail 
*
*===================================================*/
class ClassCharListDetail extends Component
  render: ! ->
    name = @props.name
    char = @props.char

    # Char maximum status
    class_data = char.class_list[*-1]

    max = class_data.max
    bonus = class_data.bonus

    return @tr {},
             @td {id: "char-name"}, char.name
             @td {id: "char-rare"}, char.rare
             @td {id: "char-class-name"}, class_data.name
             @td {}, max.lv
             @td {}, max.hp + bonus.hp
             @td {}, max.at + bonus.at
             @td {}, max.def + bonus.def
             @td {}, class_data.resist
             @td {}, class_data.range
             @td {}, class_data.block
             @td {}, class_data.max_cost

/*===================================================
*
*   Class Char List 
*
*===================================================*/
th-list = [
  \名称
  \レア
  \クラス
  \LV
  \HP
  \攻擊力
  \防禦力
  \魔法耐性
  \射程
  \ブロック
  \コスト
]

class ClassCharList extends Component
  render: ! ->
    name = @props.class_name
    list = @props.class_char_list

    if not @props.display
      display = "none"
    else
      display = ""

    return @table {className: mdl-table-style, id: "char-list-table", style:{display: display}},

             @tr {id: "char-table-header"},
               for th-value, i in th-list
                 @th {key: i}, th-value

             @tbody {},
               for char, i in list
                 ClassCharListDetail.elem {key:i, class_name: name, char: char}

/*===================================================
*
*   Char List 
*
*===================================================*/
class CharList extends Component
  handleChange: (event) ->
    id = event.target.id
    checked = event.target.checked

    if checked
      @props.add_filter id, checked
    else
      @props.remove_filter id, checked

  render: ! ->
    return @div {className: "mdl-grid"},

             @div {className: "mdl-cell mdl-cell--2-col"},
               for class_type, checked of @props.chars.class_types_map
                 @label {key: class_type, className: "mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect", htmlFor: class_type},
                   @input {type: "checkbox", id: class_type, className:"mdl-checkbox__input", checked: checked, onChange: @handleChange}
                   @span {className: "mdl-checkbox__label"},
                     class_type

             @div {className: "mdl-cell mdl-cell--10-col"},
               for class_name, class_char_list of @props.chars.class_map
                   ClassCharList.elem {
                     key: class_name
                     class_name: class_name
                     class_char_list: class_char_list
                     display: @props.chars.class_types_map[class_name]
                   }

module.exports = CharList 

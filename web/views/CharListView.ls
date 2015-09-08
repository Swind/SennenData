require! {
    "react": React
}

{div, table, thead, tbody, th, tr, td} = React.DOM

mdl-table-style = "mdl-data-table mdl-js-data-table"

/*===================================================
*
*   Class Char detail 
*
*===================================================*/
class-char-detail =
  React.createClass do
    render: ! ->
      name = @props.name
      char = @props.char

      # Char maximum status
      class_data = char.class_list[*-1]

      max = class_data.max
      bonus = class_data.bonus

      return tr {},
               td {id: "char-name"}, char.name 
               td {id: "char-rare"}, char.rare
               td {id: "char-class-name"}, class_data.name
               td {}, max.lv
               td {}, max.hp + bonus.hp
               td {}, max.at + bonus.at
               td {}, max.def + bonus.def
               td {}, class_data.resist
               td {}, class_data.range
               td {}, class_data.block
               td {}, class_data.max_cost

class-char-detail-elem = React.createFactory class-char-detail 

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

class-char-list = React.createClass do
    render: ! ->
        name = @props.class_name
        list = @props.class_char_list

        return table {className: mdl-table-style, id: "char-list-table"},

                 tr {id: "char-table-header"},
                   for th-value, i in th-list
                     th {key: i}, th-value

                 tbody {},
                   for char, i in list
                     class-char-detail-elem {key:i, class_name: name, char: char}

class-char-list-elem = React.createFactory class-char-list

/*===================================================
*
*   Char List 
*
*===================================================*/
module.exports = CharList = React.createClass do
  render: ! ->
      return div {className: "mdl-grid"},
                 div {className: "mdl-cell mdl-cell--12-col"},
                   for class_name, class_char_list of @props.chars.class_map 
                       class-char-list-elem {key: class_name, class_name: class_name, class_char_list: class_char_list}

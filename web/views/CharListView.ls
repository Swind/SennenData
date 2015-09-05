require! {
    "../dispatcher/AppDispatcher": Dispatcher
    "../constants/AppConstants": Constants
    "../stores/CharListStore": CharListStore
    "react": React
}

{div, table, thead, tbody, th, tr, td} = React.DOM

mdl-table = "mdl-data-table mdl-js-data-table"

/*===================================================
*
*   Column handler 
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

table-header = tr {},
                   for th-value, i in th-list
                       th {key: i}, th-value

class-data-td =
  React.createClass do
    render: ! ->
      class_data = @props.class_data
      char_name = @props.char_data.name
      rare = @props.char_data.rare

      max = class_data.max
      min = class_data.min
      bonus = class_data.bonus

      return tr {},
                  td {id: "char-name"}, char_name
                  td {id: "char-rare"}, rare
                  td {id: "char-class-name"}, class_data.name
                  td {}, max.lv
                  td {}, max.hp + bonus.hp
                  td {}, max.at + bonus.at
                  td {}, max.def + bonus.def
                  td {}, class_data.resist
                  td {}, class_data.range
                  td {}, class_data.block
                  td {}, class_data.max_cost

table-data =
  React.createClass do
    render: ! ->
      class-data-td-elem = React.createFactory class-data-td
      data = @props.char

      return class-data-td-elem {char_data: data, class_data: data.class_list[*-1]}

table-data-elem = React.createFactory table-data

/*===================================================
*
*   Class Char List 
*
*===================================================*/
class-char-list =
  React.createClass do
    render: ! ->
      table

class-char-list-elem = React.createFactory class-char-list

/*===================================================
*
*   Char List 
*
*===================================================*/
char-list = React.createClass do
            render: ! ->
                char_map = @props.char_map

                return div {className: "mdl-grid"},
                           div {className: "mdl-cell mdl-cell--12-col"},
                               table {className: mdl-table, id: "char-list-table"}
                                   for class-name, class-char-list of char_map
                                       char-class-list-elem {class-name: class-name, class-char-list: class-char-list}

char-list-elem = React.createFactory char-list


module.exports = CharList = React.createClass do
    getInitialState: ->
        return {
            all: CharListStore.all!
            melee: CharListStore.melee!
            range: CharListStore.range!
            melee_classes: CharListStore.melee_classes!
            range_classes: CharListStore.range_classes!
        }

    render: ->
        char-list-elem = React.createFactory char-list
        return div {},
                   div {className: "mdl-tabs__panel is-active", id:"melee-panel"},
                       char-list-elem {char_map: @state.melee_classes}
                   div {className: "mdl-tabs__panel", id:"range-panel"},
                       char-list-elem {char_map: @state.range_classes}


    componentDidMount: ->
        CharListStore.addChangeListener @._onChange

    componentWillUnmount: ->
        CharListStore.removeChangeListener @._onChange

    _onChange: ->
        console.log "Store Change"


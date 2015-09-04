require! {
    "../dispatcher/AppDispatcher": Dispatcher
    "../constants/AppConstants": Constants
    "../stores/CharStore": CharStore
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
    \Rare
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

table-header = thead {},
                   tr,
                       for th-value, i in th-list
                           th {key: i}, th-value

class-data-td = React.createClass do
                render: ! ->
                    class_data = @props.class_data
                    char_name = @props.char_data.name
                    rare = @props.char_data.rare

                    max = class_data.max
                    min = class_data.min

                    return tr {},
                                td {}, char_name
                                td {}, rare
                                td {}, class_data.name
                                td {}, max.lv
                                td {}, max.hp
                                td {}, max.at
                                td {}, max.def
                                td {}, class_data.magic
                                td {}, class_data.range
                                td {}, class_data.block
                                td {}, class_data.max_cost

table-data = React.createClass do
             render: ! ->
                 class-data-td-elem = React.createFactory class-data-td 
                 data = @props.char

                 base_class = ! ->

                 return tbody {},
                            class-data-td-elem {char_data: data, class_data: data.class_list[*-1]}

char-table = React.createClass do
            render: ! ->
                table-data-elem = React.createFactory table-data
                char_list = @props.char_list

                # Show char table by class_type
                char_map = {}
                for char in char_list
                   if not char_map[char.class_type]
                       char_map[char.class_type] = []

                   char_map[char.class_type][*] =char

                return div {className: "mdl-grid"},
                           for class_type, char_list of char_map
                               div {className: "mdl-cell mdl-cell--12-col"},
                                   table {className: mdl-table},
                                      table-header
                                      for char, i in char_list
                                          table-data-elem {key: i, char: char}


module.exports = CharList = React.createClass do
    getInitialState: ->
        return {
            all: CharStore.get_all!
            melee: CharStore.get_melee!
            range: CharStore.get_range!
        }

    render: ->
        char-table-elem = React.createFactory char-table
        return div {},
                   div {className: "mdl-tabs__panel is-active", id:"melee-panel"},
                       char-table-elem {char_list: @state.melee}
                   div {className: "mdl-tabs__panel", id:"range-panel"},
                       char-table-elem {char_list: @state.range}


    componentDidMount: ->
        CharStore.addChangeListener @._onChange

    componentWillUnmount: ->
        CharStore.removeChangeListener @._onChange

    _onChange: ->
        console.log "Store Change"


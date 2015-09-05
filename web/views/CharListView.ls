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
                    favor = class_data.favor

                    return tr {},
                                td {style: {width:"10%"}}, char_name
                                td {style: {width:"5%"}}, rare
                                td {style: {width:"15%"}}, class_data.name
                                td {}, max.lv
                                td {}, max.hp + favor.hp 
                                td {}, max.at + favor.at
                                td {}, max.def + favor.def
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
                char_map = @props.char_map

                return div {className: "mdl-grid"},
                           for class_type, char_list of char_map
                               div {className: "mdl-cell mdl-cell--12-col"},
                                   table {className: mdl-table, style: {width:"100%"}, table-layout: "fixed"},
                                      table-header
                                      for char, i in char_list
                                          table-data-elem {key: i, char: char}


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
        char-table-elem = React.createFactory char-table
        return div {},
                   div {className: "mdl-tabs__panel is-active", id:"melee-panel"},
                       char-table-elem {char_map: @state.melee_classes}
                   div {className: "mdl-tabs__panel", id:"range-panel"},
                       char-table-elem {char_map: @state.range_classes}


    componentDidMount: ->
        CharListStore.addChangeListener @._onChange

    componentWillUnmount: ->
        CharListStore.removeChangeListener @._onChange

    _onChange: ->
        console.log "Store Change"


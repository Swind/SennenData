require! {
    "../dispatcher/AppDispatcher": Dispatcher
    "../constants/AppConstants": Constants
    "../stores/CharStore": CharStore
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
                    char_name = @props.char_name

                    max = class_data.max
                    min = class_data.min

                    return tr {}, 
                                td {rowSpan:3}, char_name 
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
                            class-data-td-elem {char_name:data.name, class_data: data.class_list[0]}

module.exports = CharList = React.createClass do
    getInitialState: ->
        return {all: CharStore.get_all!}

    render: ->
        table-data-elem = React.createFactory table-data
        return div {className: "mdl-grid"},
                   div {className: "mdl-cell mdl-cell--12-col"},
                       table {className: mdl-table}, 
                            table-header
                            for char, i in @state.all
                                table-data-elem {key: i, char: char}

    componentDidMount: ->
        CharStore.addChangeListener @._onChange

    componentWillUnmount: ->
        CharStore.removeChangeListener @._onChange

    _onChange: ->
        console.log "Store Change"


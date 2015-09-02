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
    \ボーナス
]

table-header = thead {},
                   tr,
                       for th-value, i in th-list
                           th {key: i}, th-value

table-data = (data) -> do
                base_class = data.class_list[0]
                max = base_class.max

                tbody {},
                    # Base class
                    tr {},
                        td {}, data.name
                        td {}, base_class.name
                        td {}, max.lv
                        td {}, max.hp
                        td {}, max.at
                        td {}, max.def
                        td {}, base_class.magic
                        td {}, base_class.range
                        td {}, base_class.block
                        td {}, base_class.max_cost
                        td {}, base_class.favor

char-data-table = (data) -> do
                            table-data data

module.exports = CharList = React.createClass do
    getInitialState: ->
        return {all: CharStore.get_all!}

    render: ->
        return div {className: "mdl-grid"},
                   div {className: "mdl-cell mdl-cell--12-col"},
                       table {className: mdl-table}, 
                            table-header
                            for char in @state.all
                                char-data-table char

    componentDidMount: ->
        CharStore.addChangeListener @._onChange

    componentWillUnmount: ->
        CharStore.removeChangeListener @._onChange

    _onChange: ->
        console.log "Store Change"


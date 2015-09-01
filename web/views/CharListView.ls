require! {
    "../dispatcher/AppDispatcher": Dispatcher
    "../constants/AppConstants": Constants
    "../stores/CharStore": CharStore
}

{table, thead, th, tr, td} = React.DOM

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

module.exports = CharList = React.createClass do
    getInitialState: ->
        return null

    render: ->
        return table {className: mdl-table},
                   table-header

    componentDidMount: ->
        CharStore.addChangeListener @._onChange

    componentWillUnmount: ->
        CharStore.removeChangeListener @._onChange

    _onChange: ->
        console.log "Store Change"


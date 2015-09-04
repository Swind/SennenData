require! {
    "lokijs": lokijs
    "../sennen.json": sennen_data 
    "./dispatcher/AppDispatcher": dispatcher
    "./stores/CharStore": CharStore 
    "react": React
}

{div, a} = React.DOM

ListView = React.createFactory require "./views/CharListView"

App = React.createFactory React.createClass do
    getInitialState: ! ->
        return null

    render: ! ->
        return div {className: "mdl-tabs mdl-js-tabs mdl-js-ripple-effect"},
                    div {className: "mdl-tabs__tab-bar"},
                        a {href:'#melee-panel', className:'mdl-tabs__tab is-active'}, \近接型
                        a {href:'#range-panel', className:'mdl-tabs__tab'}, \遠距離型
                    ListView!

React.render App!, document.getElementById "main"

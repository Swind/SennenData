require! {
    "lokijs": lokijs
    "../sennen.json": sennen_data 
    "./dispatcher/AppDispatcher": dispatcher
    "./stores/CharStore": CharStore 
}

{div} = React.DOM

ListView = React.createFactory require "./views/CharListView"

App = React.createFactory React.createClass do
    getInitialState: ! ->
        return null

    render: ! ->
        return div {className: \char-list-panel}, 
                    ListView!

React.render App!, document.getElementById "main"

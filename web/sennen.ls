require! {
    "react": React 
    "react": {Component, PropTypes}
    "redux": {createStore}
    "react-redux": {Provider, connect}

    "./scss/sennen.scss": sennen-css

    "./reducers/AppReducer": Reducer 
    "./actions/AppActions": Action

    "./views/CharListView": CharListView
}

{div, a, header, main, span, nav} = React.DOM
char-list-view-elem = React.createFactory CharListView

class Main extends Component
  render: ! ->
    const {dispatch, melee_chars, range_chars} = @props
    return div {className: "mdl-tabs mdl-js-tabs mdl-js-ripple-effect"},
             div {className: "mdl-tabs__tab-bar"},
                 a {href:'#melee-panel', className:'mdl-tabs__tab is-active'}, \近接型
                 a {href:'#range-panel', className:'mdl-tabs__tab'}, \遠距離型
             div {className: "mdl-tabs__panel is-active", id:"melee-panel"},
               char-list-view-elem {
                 chars: melee_chars
                 add_filter: (id, checked) -> dispatch Action.add_melee_filter {"#id": checked}
                 remove_filter: (id, checked) -> dispatch Action.remove_melee_filter {"#id": checked}
                 reset_filter: (id, checked) -> dispatch Action.reset_melee_filter {"#id": checked}
               }
             div {className: "mdl-tabs__panel", id:"range-panel"},
               char-list-view-elem {
                 chars: range_chars
                 add_filter: (id, checked) -> dispatch Action.add_range_filter {"#id": checked}
                 remove_filter: (id, checked) -> dispatch Action.remove_range_filter {"#id": checked}
                 reset_filter: (id, checked) -> dispatch Action.reset_range_filter {"#id": checked}
               }

Main.propTypes = {}
main-elem = React.createFactory Main 

class Body extends Component
  componentWillMount: !->
    const {dispatch, melee_chars, range_chars} = @props

    dispatch Action.reset_melee_filter!
    dispatch Action.reset_range_filter!

  render: !->
    const {dispatch, melee_chars, range_chars} = @props

    return div {className: "mdl-layout mdl-js-layout"},

             # Header
             header {className: "mdl-layout__header"},
               div {className: "mdl-layout__header-row"}

             # Sidebar
             div {className: "mdl-layout__drawer"},
               span {className: "mdl-layout-title"},
                 \千年戦争ーアイギス
               nav {className: "mdl-navigation", id:"sidebar"}

             # Main content
             main {className:"mdl-layout__content" id:"main"},
               main-elem {
                 dispatch
                 melee_chars
                 range_chars
               }

Body.propTypes = {}
body-elem = React.createFactory connect((state)->state)(Body)

/*==================================================================================
*
*   Root component with Provider
*
*=================================================================================*/
store = createStore Reducer
root-elem = document.getElementById "body"

provider-elem = React.createElement Provider, {store: store}, body-elem
React.render (div {}, [provider-elem]), root-elem

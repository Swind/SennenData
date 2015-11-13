require! {
  "react-dom": ReactDOM
  "react": React

  "./react-wrapper": {Component, apply-provider}

  "./scss/sennen.scss": sennen-css

  "./reducers/AppReducer": Reducer 
  "./actions/AppActions": Action

  "./views/CharListView": CharListView
}

class Main extends Component
  render: ! ->
    const {dispatch, melee_chars, range_chars} = @props

    return @div {className: "mdl-tabs mdl-js-tabs mdl-js-ripple-effect"},
             @div {className: "mdl-tabs__tab-bar"},
                 @a {href:'#melee-panel', className:'mdl-tabs__tab is-active'}, \近接型
                 @a {href:'#range-panel', className:'mdl-tabs__tab'}, \遠距離型
             @div {className: "mdl-tabs__panel is-active", id:"melee-panel"},
               CharListView.elem {
                 chars: melee_chars
                 add_filter: (id, checked) -> dispatch Action.add_melee_filter {"#id": checked}
                 remove_filter: (id, checked) -> dispatch Action.remove_melee_filter {"#id": checked}
                 reset_filter: (id, checked) -> dispatch Action.reset_melee_filter {"#id": checked}
               }
             @div {className: "mdl-tabs__panel", id:"range-panel"},
               CharListView.elem {
                 chars: range_chars
                 add_filter: (id, checked) -> dispatch Action.add_range_filter {"#id": checked}
                 remove_filter: (id, checked) -> dispatch Action.remove_range_filter {"#id": checked}
                 reset_filter: (id, checked) -> dispatch Action.reset_range_filter {"#id": checked}
               }

class Body extends Component
  componentWillMount: !->
    const {dispatch, melee_chars, range_chars} = @props

    dispatch Action.reset_melee_filter!
    dispatch Action.reset_range_filter!

  render: !->
    const {dispatch, melee_chars, range_chars} = @props

    return @div {className: "mdl-layout mdl-js-layout"},

             # Header
             @header {className: "mdl-layout__header"},
               @div {className: "mdl-layout__header-row"}

             # Sidebar
             @div {className: "mdl-layout__drawer"},
               @span {className: "mdl-layout-title"},
                 \千年戦争ーアイギス
               @nav {className: "mdl-navigation", id:"sidebar"}

             # Main content
             @main {className:"mdl-layout__content" id:"main"},
               Main.elem {
                 dispatch
                 melee_chars
                 range_chars
               }

map-state-to-props = (state) ->
  state

ConnectedBody = Body.connect map-state-to-props

/*==================================================================================
*
*   Root component with Provider
*
*=================================================================================*/
root-elem = document.getElementById "body"

ReactDOM.render (React.create-element (apply-provider ConnectedBody, Reducer), null), root-elem

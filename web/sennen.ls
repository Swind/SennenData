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

{div, a} = React.DOM
char-list-view-elem = React.createFactory CharListView

class App extends Component
    componentWillMount: !->
      const {dispatch, melee_chars, range_chars} = @props

      dispatch Action.reset_melee_filter!
      dispatch Action.reset_range_filter!

    render: ! ->
      const {dispatch, melee_chars, range_chars} = @props

      return div {className: "mdl-tabs mdl-js-tabs mdl-js-ripple-effect"},
                  div {className: "mdl-tabs__tab-bar"},
                      a {href:'#melee-panel', className:'mdl-tabs__tab is-active'}, \近接型
                      a {href:'#range-panel', className:'mdl-tabs__tab'}, \遠距離型
                  div {className: "mdl-tabs__panel is-active", id:"melee-panel"},
                    char-list-view-elem {
                      chars: melee_chars
                      add_filter: Action.add_melee_filter
                      remove_filter: Action.remove_melee_filter
                      reset_filter: Action.reset_melee_filter
                    }
                  div {className: "mdl-tabs__panel", id:"range-panel"},
                    char-list-view-elem {
                      chars: range_chars
                      add_filter: Action.add_range_filter
                      remove_filter: Action.remove_range_filter
                      reset_filter: Action.reset_range_filter
                    }

App.propTypes = {}


app-elem = React.createFactory connect((state)->state)(App)

/*==================================================================================
*
*   Root component with Provider
*
*=================================================================================*/
store = createStore Reducer
root-elem = document.getElementById "main"

provider-elem = React.createElement Provider, {store: store}, app-elem 

React.render provider-elem, root-elem

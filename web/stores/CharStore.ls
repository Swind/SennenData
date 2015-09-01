require! {
    "../constants/AppConstants":Constants 
    "../dispatcher/AppDispatcher": Dispatcher 
    "events": events
    "lokijs": lokijs
    "../../sennen.json": sennen_data 
}

db = new lokijs
db.loadJSON JSON.stringify sennen_data
char = db.getCollection \char

module.exports = CharStore = new events.EventEmitter! <<< do
    emitChange: ->
        @emit Constants.CHANGE_EVENT

    addChangeListener: (callback) ->
        @on Constants.CHANGE_EVENT, callback

    removeChangeListener: (callback) ->
        @removeListener Constants.CHANGE_EVENT, callback

    get_all: ->
        return char.find!

/*
CharStore.dispatchToken = Dispatcher.register ({action}) ->
    switch action.type
        | Constants.CHANGE_EVENT => 
*/

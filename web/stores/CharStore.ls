require! {
    "../constants/AppConstants":Constants 
    "../dispatcher/AppDispatcher": Dispatcher 
    "events": events
    "lokijs": lokijs
    "../../sennen.json": sennen_data 
    "react": React
}

# Import all char to lokijs for searching
db = new lokijs
char_db = db.addCollection \char

for item in sennen_data
    char_db.insert item

module.exports = CharStore = new events.EventEmitter! <<< do
    emitChange: ->
        @emit Constants.CHANGE_EVENT

    addChangeListener: (callback) ->
        @on Constants.CHANGE_EVENT, callback

    removeChangeListener: (callback) ->
        @removeListener Constants.CHANGE_EVENT, callback

    get_all: ->
        return char_db.find!

    get_melee: ->
        return char_db.find {type:\melee}

    get_range: ->
        return char_db.find {type:\range}

/*
CharStore.dispatchToken = Dispatcher.register ({action}) ->
    switch action.type
        | Constants.CHANGE_EVENT => 
*/

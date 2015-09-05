require! {
    "../constants/AppConstants":Constants 
    "../dispatcher/AppDispatcher": Dispatcher 
    "./DB": DB
    "events": events
    "react": React
}

melee = DB.chain!.find {type: \melee}
range = DB.chain!.find {type: \range}

map_func = (obj)->obj.class_type
reduce_func = (array)-> new Set(array)

melee_classes_list = melee.mapReduce map_func, reduce_func
range_classes_list = range.mapReduce map_func, reduce_func

module.exports = CharListStore = new events.EventEmitter! <<< do
    emitChange: ->
        @emit Constants.CHANGE_EVENT

    addChangeListener: (callback) ->
        @on Constants.CHANGE_EVENT, callback

    removeChangeListener: (callback) ->
        @removeListener Constants.CHANGE_EVENT, callback


    all: ->
        return DB.find!

    melee: ->
        return melee.data! 

    range: ->
        return range.data! 

    melee_classes: ->
        classes = {}

        melee_classes_list.forEach (item)->
            classes[item] = melee.copy!.find({class_type: item}).data!

        return classes

    range_classes: ->
        classes = {}

        range_classes_list.forEach (item)->
            classes[item] = range.copy!.find({class_type: item}).data!

        return classes

/*
CharStore.dispatchToken = Dispatcher.register ({action}) ->
    switch action.type
        | Constants.CHANGE_EVENT => 
*/

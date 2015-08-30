require! {
    "../constants/AppConstants": AppConstants
}

Dispatcher = Flux.Dispatcher

module.exports = AppDispatcher = new Dispatcher! <<< do
    handleFilterAction: (action) ->
        @dispatch {
            action: action
            source: AppConstants.SOURCE_FILTER_ACTION
        }

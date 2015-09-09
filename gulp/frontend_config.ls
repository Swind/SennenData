require! {
    "html-webpack-plugin": HtmlWebpackPlugin
    "webpack": webpack
}

bower_dir = __dirname + "/../bower_components"
node_dir = __dirname + "/../node_modules"
build_dir = __dirname + "/../build"

addVendor = (type, name, path, config) ->
    config.resolve.alias[name] = path

    config.module.noParse.push new RegExp name

    if type == \js
        config.entry.vendors.push name

frontendDevConfig = {

    entry: {
        webpack-dev-server: "webpack-dev-server/client?http://0.0.0.0:8080"
        only-dev-server: "webpack/hot/only-dev-server"
        bundle: "./web/sennen.ls"
        vendors: []
    }
    module:{
        noParse: []
        loaders: [
              * test: /\.css$/
                loader: 'style-loader!css-loader'

              * test: /\.scss$/
                loader: 'style!css!sass'

              * test: /\.ls$/
                loaders: ["react-hot", "livescript-loader"]
                exclude: /node_modules/

              * test: /\.json$/
                loader: "json-loader"
        ]
    }
    resolve:{
        alias:{
        }
        extensions: ['', '.ls', '.js', '.json']
    }
    output: {
        path: build_dir 
        filename: "[name].js"
    }
    plugins: [
        new HtmlWebpackPlugin {
            template: "web/index.html"
            inject: true 
        }
        new webpack.optimize.CommonsChunkPlugin "vendors", "vendors.js"
        new webpack.HotModuleReplacementPlugin!
    ]
    devtool: \sourcemap
    debug: true
}

addVendor \js, \lokijs, node_dir + "/lokijs/src/lokijs.js", frontendDevConfig

frontendConfig = ! ->
    config = {} <<< frontendDevConfig

    delete config[\devtool]
    delete config[\debug]

    return config


module.exports = {
    dev: frontendDevConfig
    production: frontendConfig!
}

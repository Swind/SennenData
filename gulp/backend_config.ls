require! {
    "fs": fs
    "webpack": webpack
}

nodeModules = {}
bower_dir = __dirname + "/../bower_components"
node_dir = __dirname + "/../node_modules"
build_dir = __dirname + "/../build"

fs.readdirSync \node_modules
  .filter (x)->
      [\bin].indexOf x === -1
  .forEach (mod)->
      nodeModules[mod] = "commonjs " + mod

backendConfig = {
    module:{
        loaders:
          * test: /\.ls$/
            loader: "livescript-loader"
            exclude: /node_modules/

          * test: /\.json$/
            loader: "json-loader"
    }
    entry: {
      parser: "./parser/sennen.ls"
      crawler: "./parser/raw.ls"
    }
    target: \node
    output:{
        path: "./build"
        filename: "[name].js"
    }

    plugins: [
        new webpack.IgnorePlugin /\.(css|less|scss|sass)$/
        new webpack.ResolverPlugin(
            new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
        ),
        new webpack.BannerPlugin('require("source-map-support").install();',
                                 { raw: true, entryOnly: false })
    ]
    resolve: {
        extensions: ['', '.ls', '.js', '.json']
    }
    externals: nodeModules
    devtool: \sourcemap
    debug: true
}

module.exports = backendConfig

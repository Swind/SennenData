require! {
    gulp
    "gulp-util": gutil
    "deep-merge": DeepMerge
    "path": path
    "webpack": webpack
    "webpack-dev-server": WebpackDevServer 
    "fs": fs
    "html-webpack-plugin": HtmlWebpackPlugin
}

/*==========================================================
*
*    Global variables 
*
============================================================*/

bower_dir = __dirname + "/../bower_components"
node_dir = __dirname + "/../node_modules"
build_dir = __dirname + "/../build"

defaultConfig = {
    cache: true
    module:{
        loaders:
          * test: /\.ls$/
            loader: "livescript-loader"
            exclude: /node_modules/

          * test: /\.json$/
            loader: "json-loader"

          * test: /\.(png|jpg|gif)$/
            loader: "url-loader?limit=8192"

          * test: /\.css$/
            loader: 'style-loader!css-loader'

          * test: /\.scss$/
            loader: 'style!css!sass'

          * test: /\.jpe?g$|\.gif$|\.png$|\.svg$|\.woff$|\.ttf$|\.wav$|\.mp3$|\.woff2|\.eot/
            loader: "file"

    }
    resolve: {
        extensions: ['', '.ls', '.js', '.json']
    }
}

if process.env.NODE_ENV !== \production
    defaultConfig.devtool = 'sourcemap'
    defaultConfig.debug = true

/*==========================================================
*
*    Utils 
*
============================================================*/
deepmerge = DeepMerge (target, source, key)->
    if target instanceof Array
       return [].concat target, source

    return source

nodeModules = {}

fs.readdirSync \node_modules
  .filter (x)->
      [\bin].indexOf x === -1
  .forEach (mod)->
      nodeModules[mod] = "commonjs " + mod

addVendor = (type, name, path, config) ->
    config.resolve.alias[name] = path

    config.module.noParse.push new RegExp name

    if type == \js
        config.entry.vendors.push name

config = (overrides) ->
    return deepmerge defaultConfig, overrides || {}

onBuild = (done)->
    return (err, stats) ->
        if err
            console.log \Error, err
        else
            console.log stats.toString!

        if done
            done!

/*==========================================================
*
*    Frontend 
*
============================================================*/

frontendConfig = config {
    entry: {
        bundle: "./web/sennen.ls"
        vendors: []
    }
    module:{
        noParse: []
    }
    resolve:{
        alias:{
        }
    }
    output: {
        path: build_dir 
        filename: "frontend.js"
    }
    plugins: [
        new HtmlWebpackPlugin {
            template: "web/index.html"
            inject: true
        }
        new webpack.optimize.CommonsChunkPlugin "vendors", "vendors.js"
    ]
}

addVendor \js, \lokijs, node_dir + "/lokijs/src/lokijs.js", frontendConfig

gulp.task \frontend-build, (done)->
    webpack(frontendConfig).run onBuild done

gulp.task \frontend-watch, (done)->
    webpack(frontendConfig).watch 100, onBuild!

gulp.task \dev-server, (done)->
    compiler = webpack frontendConfig
    new WebpackDevServer(compiler, {
        contentBase: "./build/"
        hot: true
        watchOptions:
            aggregateTimeout: 100
            poll: 300
    }).listen 8080, \localhost, (err) ->
        if err
            throw new gutil.PluginError \webpack-dev-server, err

        gutil.log "[webpack-dev-server]", "http://localhost:8080/index.html"

    done!

/*==========================================================
*
*    Backend 
*
============================================================*/
backendConfig = config {
  entry: "./senne.ls"
  target: \node
  output:{
    path: "./build"
    public:Path: "build/"
    filename: \backend.js
  }

  plugins: [
    new webpack.IgnorePlugin /\.(css|less|scss|sass)$/
    new webpack.ResolverPlugin(
        new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
    ),
    new webpack.BannerPlugin('require("source-map-support").install();',
                             { raw: true, entryOnly: false })
  ]

  externals: nodeModules
}


gulp.task \backend-build, (done)->
    webpack(backendConfig).run onBuild done

gulp.task \backend-watch, (done)->
    webpack(backendConfig).watch 100, onBuild!

/*==========================================================
*
*    Gulp webpack task 
*
============================================================*/
gulp.task \build, [\backend-build]
gulp.task \watch, [\backend-watch]

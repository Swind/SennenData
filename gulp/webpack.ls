require! {
    gulp
    "gulp-util": gutil
    "deep-merge": DeepMerge
    "path": path
    "webpack": webpack
    "fs": fs
}

/*==========================================================
*
*    Global variables 
*
============================================================*/

bower_dir = __dirname + "/../bower_components"

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

    config.module.noParse.push new RegExp '^' + name + '$'

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

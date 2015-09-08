require! {
    gulp
    "gulp-util": gutil
    "deep-merge": DeepMerge
    "path": path
    "webpack": webpack
    "webpack-dev-server": WebpackDevServer 
    "fs": fs
    "./frontend_config": frontendConfig
    "./backend_config": backendConfig
}

/*==========================================================
*
*    Utils 
*
============================================================*/
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
gulp.task \frontend-build, (done)->
    config = frontendConfig.production
    config.plugins[*] = new webpack.optimize.UglifyJsPlugin!

    webpack(frontendConfig.production).run onBuild done

gulp.task \dev-server, (done)->
    compiler = webpack frontendConfig.dev
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

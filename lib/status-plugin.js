"use strict";

var webpack = require("webpack");

function WebpackDriverStatusPlugin(options) {
    this.options = options;
}

function log(type, value) {
    console.log('STATUS:', JSON.stringify({type, value}));
}

WebpackDriverStatusPlugin.prototype.apply = function(compiler) {
    var timer;

    if ( compiler.options.devServer ) {
        let {port, host, outputPath} = compiler.options.devServer;
        log("dev-server", { port, host, outputPath });
    }

    compiler.apply(new webpack.ProgressPlugin(function (percent, msg) {
        log("compile", {
            "progress":  percent,
            "operation": msg,
            "ms": Date.now() - timer
        });
    }));

    compiler.plugin("compile", function() {
        timer = Date.now();
        log("compile", {
            "progress":  0,
            "operation": "idle"
        })
    });

    compiler.plugin("invalid", function() {
        log("status", "invalid");
    });

    compiler.plugin("after-environment", function() {
        log("config", { output_path: compiler.options.output.path });
    })

    compiler.plugin("failed-module", function(module) {
        log("failed-module", module);
    });
    compiler.plugin("done", function(stats) {
        if (stats.compilation.errors && stats.compilation.errors.length){
            log("status", "invalid");
            for(var i = 0; i < stats.compilation.errors.length; i++){
                var err = stats.compilation.errors[i];
                log("error", {
                    name: err.name, message: err.message,
                    resource: err.module ? err.module.resource : ''
                });
            }
        } else {
            log("status", "success");
        }
    });

    compiler.plugin("failed", function() {
        log("status", "failed");
    });

    compiler.plugin("valid", function() {
        log("status", "valid");
    });

    // https://gist.github.com/kisenka/b31d3dd1d1a9182dde0bb3e3efe1a038
    compiler.plugin("emit", function(compilation, callback) {
        const assets = compilation.getStats().toJson().assets;
        assets.forEach(function(asset) {
            if (asset.chunkNames.length) {
                log("asset", {id: asset.chunkNames[0], file: asset.name, size: asset.size});
            }
        });
        callback();
    });

}

module.exports = WebpackDriverStatusPlugin;

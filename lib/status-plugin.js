"use strict";

function log(type, value) {
    console.log('STATUS:', JSON.stringify({type, value}));
}

function WebpackDriverStatusPlugin(options) {
    this.options = options;
}

WebpackDriverStatusPlugin.prototype.apply = function(compiler) {
    var timer;

    if ( compiler.options.devServer ) {
        let {port, host, outputPath} = compiler.options.devServer;
        log("dev-server", { port, host, outputPath });
    }

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
        const chunks = compilation.getStats().toJson().chunks;
        chunks.forEach(function(chunk) {
            if (chunk.names.length && chunk.initial) {
                log("asset", {
                    id: chunk.names[0], files: chunk.files, size: chunk.size
                });
            }
        });
        callback();
    });
}

module.exports = WebpackDriverStatusPlugin;

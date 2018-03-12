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


    const addHook = (name, cb) => {
        if (compiler.hooks) {
            compiler.hooks[name].tap('WebPackDriver', cb);
        } else {
            compiler.plugin(name, cb);
        }
    }

    addHook('compile', () => {
        log("status", "compiling");
    });

    addHook('done', (stats) => {
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

    addHook('emit', (compilation, callback) => {
        const chunks = compilation.getStats().toJson().chunks;
        chunks.forEach(function(chunk) {
            if (chunk.names.length && chunk.initial) {
                log("asset", {
                    id: chunk.names[0], files: chunk.files, size: chunk.size
                });
            }
        });
        if (callback) { callback(); }
    });

}

module.exports = WebpackDriverStatusPlugin;

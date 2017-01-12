module WebpackDriver

    class ConfigOptions

        attr_accessor :port
        attr_accessor :directory
        attr_accessor :environment
        attr_accessor :compile_script
        attr_accessor :dev_server_script

        def initialize
            @directory = Pathname.new(Dir.pwd)
            @environment = 'development'
            @compile_script = 'node_modules/webpack/bin/webpack.js'
            @dev_server_script = 'node_modules/webpack-dev-server/bin/webpack-dev-server.js'        end

        def after_configuration
            @directory = Pathname.new(@directory)
        end

    end

end

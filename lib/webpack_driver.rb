require_relative "webpack_driver/version"
require_relative "webpack_driver/config_options"
require_relative "webpack_driver/configuration"
require_relative "webpack_driver/asset"
require_relative 'webpack_driver/process'
require_relative "webpack_driver/dev_server"
require_relative "webpack_driver/compile"
require_relative "webpack_driver/errors"

module WebpackDriver

    def self.config
        @config ||= WebpackDriver::ConfigOptions.new
        if block_given?
            yield @config
            @config.after_configuration
        end
        @config
    end

end

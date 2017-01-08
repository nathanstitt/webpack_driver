require_relative "ruby_pack/version"
require_relative "ruby_pack/config_options"
require_relative "ruby_pack/configuration"
require_relative 'ruby_pack/process'
require_relative "ruby_pack/dev_server"
require_relative "ruby_pack/compile"
require_relative "ruby_pack/errors"

module RubyPack

    def self.config
        @config ||= RubyPack::ConfigOptions.new
        if block_given?
            yield @config
            @config.after_configuration
        end
        @config
    end

end

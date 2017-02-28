require 'logger'
require 'pathname'
require_relative 'configuration/generated'
require_relative 'configuration/example'

module WebpackDriver

    class Configuration

        attr_accessor :port
        attr_accessor :logger
        attr_accessor :compile_script
        attr_accessor :directory
        attr_accessor :cmd_line_flags
        attr_writer   :environment

        attr_reader :file
        attr_reader :generated
        attr_accessor :logger

        ROOT = Pathname.new(__FILE__).dirname.join('..', '..')

        def initialize(file = './webpack.config.js', options = {})
            options.each { |k, v| send("#{k}=", v) }
            @directory ||= '.'
            @file = Pathname.new(file)
            @generated = Tempfile.new(['webpack.config', '.js'])
            Generated.new([], config: self).invoke_all
        end

        def generate!
            Example.new([], config: self).invoke_all
        end

        def present?
            file.exist?
        end

        def path
            @generated.path
        end

        def gem_root
            ROOT
        end

        def environment
            @environment ||= { NODE_ENV: 'development' }
        end

        def flags
            opts = ['--config', path]
            opts += ['--port', port] if port
            opts += cmd_line_flags if cmd_line_flags
            opts
        end

        def logger
            @logger ||= Logger.new(STDOUT)
        end

    end

end

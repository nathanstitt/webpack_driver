require 'logger'
require 'pathname'
require_relative 'configuration/generated'
require_relative 'configuration/example'

module WebpackDriver

    class Configuration

        attr_accessor :port
        attr_accessor :logger
        attr_accessor :compile_script
        attr_accessor :tmp_directory
        attr_accessor :cmd_line_flags
        attr_accessor :output_path
        attr_writer   :environment
        attr_accessor :file
        attr_accessor :directory
        attr_accessor :logger

        attr_reader :process



        ROOT = Pathname.new(__FILE__).dirname.join('..', '..')

        def initialize(options = {})
            options.each { |k, v| send("#{k}=", v) }
            @file = Pathname.new(file) unless file.nil?
            @directory ||= Pathname.getwd
            @output_path ||= @directory.join('public', 'assets')
            @tmp_directory ||= @directory.join('tmp')
            @generated = Generated.new([], config: self)
            @generated.invoke_all
        end

        def manifest_file
            output_path.join('manifiest.json')
        end

        def generate!
            Example.new([], config: self).invoke_all
        end

        def present?
            file.exist?
        end

        def gem_root
            ROOT
        end

        def environment
            @environment ||= { NODE_ENV: 'development' }
        end

        def flags
            opts = ['--config', @generated.path.to_s]
            opts += ['--port', port] if port
            opts += cmd_line_flags if cmd_line_flags
            opts
        end

        def logger
            @logger ||= Logger.new(STDOUT)
        end

        def launch(development:)
            raise "Already launched" unless @process.nil?
            logger.info "Startint"
            @process = development ? DevServer.new(self) : Compile.new(self)
        end

    end
end

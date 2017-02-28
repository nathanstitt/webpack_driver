require 'concurrent/array'
require 'concurrent/map'
require 'childprocess'
require 'json'

module WebpackDriver

    class Process
        READ_CHUNK_SIZE = 1024

        extend Forwardable

        def_delegators :@proc, :alive?, :environment, :wait

        attr_reader :assets, :messages
        attr_reader :config

        def initialize(script, config)
            self.reset!
            @config = config
            args = ["./node_modules/.bin/#{script}"] + config.flags

            @proc = ::ChildProcess.build(*args)

            @proc.environment.merge!(
                config.environment
            )
            @proc.cwd = config.directory
        end

        def start
            self.reset!
            @output, w = IO.pipe
            @proc.io.stdout = @proc.io.stderr = w
            @proc.start
            w.close
            @listener = listen_for_status_updates
        end

        def stop
            @proc.stop
            @output.close unless @output.closed?
            @listener.join
        end

        def valid?
            last_compilation_message['operation'] == 'emit'
        end

        protected

        def reset!
            @assets = Concurrent::Map.new
            @messages = Concurrent::Array.new
        end

        def last_compilation_message
            msg = @messages.reverse_each.detect{ |l| l['type'] == 'compile' }
            msg ? msg['value'] : {}
        end

        def record_error(error)
            config.logger.error(
                "#{error['name']}: #{error['resource']}\n#{error['message']}"
            )
        end

        def record_message(msg)
            case msg['type']
            when 'asset'
                name = msg['value']['name']
                @assets[name] = Asset.new(name, msg['value']['size'])
            when 'error'
                record_error(msg['value'])
            else
                config.logger.debug(msg)
            end
            @messages << msg
        end


        def listen_for_status_updates
            Thread.new do
                @output.each_line do | l |
                    match = l.match(/^STATUS: (.*)/)
                    if match
                        record_message(JSON.parse(match[1]))
                        config.logger.debug(l.chomp)
                    else
                        config.logger.info(l.chomp)
                    end
                end
            end
        end

    end
end

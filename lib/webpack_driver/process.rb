require 'concurrent/array'
require 'concurrent/map'
require 'childprocess'
require 'json'

module WebpackDriver

    class Process
        READ_CHUNK_SIZE = 1024

        extend Forwardable

        attr_reader :assets, :buffer

        def initialize(*flags)
            self.reset!
            args = ["node"] + flags
            @proc = ::ChildProcess.build(*args)
            @proc.environment['NODE_ENV'] = WebpackDriver.config.environment
            @proc.cwd = WebpackDriver.config.directory
        end

        def alive?
            @proc.alive?
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
            @output.close unless @output.closed?
            @proc.stop
            @listener.join
        end

        def valid?
            last_compilation_message['operation'] == 'emit'
        end

        protected

        def reset!
            @assets = Concurrent::Map.new
            @buffer = Concurrent::Array.new
        end

        def last_compilation_message
            msg = @buffer.reverse_each.detect{ |l| l['type'] == 'compile' }
            msg ? msg['value'] : {}
        end

        def record_message(msg)
            if msg['type'] == 'asset'
                name = msg['value']['name']
                @assets[name] = Asset.new(name, msg['value']['size'])
            end
            @buffer << msg
        end


        def listen_for_status_updates
            Thread.new do
                @output.each_line do | l |
                    match = l.match(/STATUS: (.*)/)
                    record_message(JSON.parse(match[1])) if match
                end
            end
        end

    end
end

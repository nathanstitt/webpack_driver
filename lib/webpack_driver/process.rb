require 'childprocess'
require 'irb'
require 'scanf'

module WebpackDriver

    class Process
        READ_CHUNK_SIZE = 1024

        extend Forwardable

        def initialize(*flags)
            @buffer = ''
            args = ["node"] + flags
            @proc = ::ChildProcess.build(*args)
            @proc.environment['NODE_ENV'] = WebpackDriver.config.environment
            @proc.cwd = WebpackDriver.config.directory
        end

        def alive?
            @proc.alive?
        end

        def start
            @buffer.delete!
            @output, w = IO.pipe
            @proc.io.stdout = @proc.io.stderr = w
            @proc.start
            w.close
        end

        def stop
            @proc.stop
            read_available
            @output.close
        end

        def output
            read_available
            @buffer
        end

        def assets
            @assets ||= read_assets
        end

        protected

        def read_assets
            assets = {}
            output.scan(/\s+\[\d+\]\s+(?:\.\/)?(\S+)\s+(.*?)\s\{/) do |name, size|
                assets[name] = Asset.new(name, size)
            end
            assets
        end

        def read_available
            return if @output.nil? || @output.closed?
            begin
                loop{ @buffer << @output.read_nonblock(READ_CHUNK_SIZE) }
            rescue IO::EAGAINWaitReadable, EOFError
            end
        end

    end
end

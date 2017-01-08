require 'childprocess'

module RubyPack

    class Process
        READ_CHUNK_SIZE = 1024

        extend Forwardable

        def_delegators :@proc, :alive?

        def initialize(*flags)
            @buffer = ''
            args = ["node"] + flags
            @proc = ::ChildProcess.build(*args)
            @proc.environment['NODE_ENV'] = RubyPack.config.environment
            @proc.cwd = RubyPack.config.directory
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

        protected

        def read_available
            return if @output.closed?
            begin
                loop{ @buffer << @output.read_nonblock(READ_CHUNK_SIZE) }
            rescue IO::EAGAINWaitReadable, EOFError
            end
        end

    end
end

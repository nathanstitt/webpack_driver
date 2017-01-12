class ProcessMock
    IO = Struct.new(:stdout, :stderr)

    attr_reader :environment, :io
    attr_accessor :cwd

    def initialize(output: , runtime: 0.1)
        @output = HelperMethods::FIXTURES.join(output.to_s + '.txt').read
        @runtime = runtime
        @environment = {}
        @alive = false
        @io = IO.new
    end

    def alive?
        @alive
    end

    def build(args)
        @args = args
    end

    def stop
        @alive = false
    end

    def start
        @alive = true
        @io.stdout.write @output
        Thread.new do
            sleep @runtime
            @alive = false
        end
    end

end

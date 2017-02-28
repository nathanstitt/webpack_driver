require "minitest"
require "minitest/autorun"

require_relative './process_mock.rb'
require_relative '../lib/webpack_driver.rb'

module HelperMethods
    FIXTURES =  Pathname.new(__FILE__).dirname.join('fixtures')

    def create_process(klass, config:, output:, runtime: 0.1, stub: true)
        if stub
            ChildProcess.stub(
                :build, ProcessMock.new(output: output, runtime: runtime)
            ) do
                klass.new(config)
            end
        else
            klass.new(config)
        end
    end

    def test_configuration(options = {})
        WebpackDriver::Configuration.new('/tmp/test-webpack.config.js', options)
    end

    def process_output(name)
        FIXTURES.join(name.to_s + '.txt').read
    end
end



class MiniTest::Test
    include HelperMethods
    alias_method :run_without_around, :run
    def run(*args)
        if defined?(around)
            around { run_without_around(*args) }
        else
            run_without_around(*args)
        end
        self
    end
end

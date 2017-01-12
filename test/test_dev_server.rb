require_relative './test_helper'

OUTPUT=<<END_OUTPUT
END_OUTPUT

class TestDevServer < MiniTest::Test

    def around
        with_basic_config do
            yield
        end
    end

    def test_starting_dev_server
        process = create_process(
            WebpackDriver::DevServer,
            arguments: ['--port', '1233'],
            output: :simple_dev_server,
            runtime: 1.1
        )
        process.start
        assert process.alive?
        sleep(1.0)

        assert process.valid?

        process.stop
        refute process.valid?
        assert_equal 1, process.assets.length
        assert_equal '42 bytes', process.assets['index.js'].size
        assert_equal "http://localhost:1233/webpack-dev-server/", process.serving_from_url
        assert_equal 1233, process.serving_from_port
    end

end

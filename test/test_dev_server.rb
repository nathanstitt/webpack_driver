require_relative './test_helper'

class TestDevServer < MiniTest::Test

    def test_starting_dev_server
        process = create_process(WebpackDriver::DevServer,
                                 stub: true,
                                 config: test_configuration(port: '1833'),
                                 output: :simple_dev_server,
                                 runtime: 0.3)
        begin
            process.start
            assert process.alive?
            # process.wait
            sleep(0.2) # test that process is still running, needs increased if not mocked
            assert_equal 1, process.assets.size
            assert_equal 1425, process.assets[:bundle].size
            assert_equal "localhost", process.host
            assert_equal 1833, process.port
            assert process.alive?
            assert process.valid?
            process.stop
            refute process.alive?
            refute process.valid?
        ensure
            process.stop
        end
    end

end

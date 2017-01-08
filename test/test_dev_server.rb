class TestDevServer < MiniTest::Test

    def around
        with_basic_config do
            yield
        end
    end

    def test_starting_dev_server
        process = RubyPack::DevServer.new
        process.start
        assert process.alive?
        sleep(2)
        assert process.valid?
        process.stop
        refute process.valid?
    end

end

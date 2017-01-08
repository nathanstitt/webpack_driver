require_relative './test_helper'


class TestCompiles < MiniTest::Test

    def around
        with_basic_config do
            yield
        end
    end

    def test_compiling
        process = RubyPack::DevServer.new
        refute process.valid?
        process.start
        refute process.valid?
        sleep(2)
        assert process.valid?
    end

end

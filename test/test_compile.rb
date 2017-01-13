require_relative './test_helper'

class TestCompiles < MiniTest::Test

    def around
        with_basic_config do
            yield
        end
    end


    def test_compiling
        process = create_process(WebpackDriver::Compile,
                                 output: :simple_compile)
        refute process.valid?
        process.start
        refute process.valid?
        sleep(0.2) # let process complete, needs increased if not mocked
        refute process.alive?
        assert process.valid?
    end


    def test_reading_assets
        process = create_process(WebpackDriver::Compile, output: :simple_compile)
        process.start
        sleep(0.2) # let process complete, needs increased if not mocked
        assert_equal 1, process.assets.size
        assert_equal 1425, process.assets['bundle.js'].size
    end

end

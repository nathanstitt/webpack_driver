require_relative './test_helper'

class TestCompiles < MiniTest::Test

    def around
        with_basic_config do
            yield
        end
    end

    def test_compiling
        process = create_process(WebpackDriver::Compile, output: :simple_compile)
        refute process.valid?
        process.start
        refute process.valid?
        sleep(1)
        assert process.valid?
        assert_equal process_output(:simple_compile), process.output
    end

    def test_reading_assets
        process = create_process(WebpackDriver::Compile, output: :simple_compile)
        process.start
        assert_equal 1, process.assets.length
        assert_equal '37 bytes', process.assets['index.js'].size
    end

end

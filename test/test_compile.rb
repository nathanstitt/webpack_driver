require_relative './test_helper'

class TestCompiles < MiniTest::Test

    def test_compiling
        process = create_process(WebpackDriver::Compile,
                                 config: test_configuration,
                                 output: :simple_compile)

        refute process.valid?
        process.start
        refute process.valid?
#        process.wait
        sleep(0.2) # let process complete, needs increased if not mocked
        refute process.alive?
        assert process.complete?
        assert process.valid?
        assert process.config.manifest_file.exist?
        updated = WebpackDriver::Compile.new(test_configuration)
        assert_equal [:bundle], updated.assets.keys
    end

    def test_reading_assets
        process = create_process(WebpackDriver::Compile,
                                 config: test_configuration,
                                 output: :simple_compile)
        process.start
        sleep(0.2) # let process complete, needs increased if not mocked
        assert_equal 1, process.assets.size
        assert_equal 1425, process.assets[:bundle].size
    end
end

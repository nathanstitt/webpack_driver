require_relative './test_helper'

require 'webpack_driver/configuration'

class TestConfiguration < MiniTest::Test

    def test_webpack_config_adds_plugin
        config = WebpackDriver::Configuration.new(
            file: '/tmp/test-webpack.config.js', port: 233
        )
        refute config.present?
        assert_equal(config.port, 233)
    end

    def test_flags
        config = test_configuration(
            port: 233, environment: 'dev'
        )
        assert_equal config.flags[2..-1], ["--port", 233]
    end

    def test_configuration_generation
        Dir.mktmpdir do | dir |
            config = WebpackDriver::Configuration.new(file: "#{dir}/webpack.config.js")
            refute config.present?
            package = Class.new {
                define_method(:installed?) { false }
                define_method(:'dependency_type=') { |t| t }
                define_method(:add) { true }
            }.new
            Knitter::Package.stub :new, package do
                config.generate!
            end
            files = Dir.glob("#{dir}/*").map {|f| File.basename(f) }
            assert_includes(files, 'webpack.config.js')
        end
    end

end

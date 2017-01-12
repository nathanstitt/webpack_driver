require_relative './test_helper'

require 'webpack_driver/configuration'

class TestConfiguration < MiniTest::Test

    def test_webpack_config_generates
        with_basic_config do
            dir = WebpackDriver.config.directory
            assert dir.join('webpack.config.js').exist?
            assert dir.join('package.json').exist?
            assert dir.join('yarn.lock').exist?
        end
    end

end

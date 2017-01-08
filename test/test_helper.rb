require "minitest"
require "minitest/autorun"

require 'pry'
require_relative '../lib/ruby_pack.rb'

module HelperMethods
    FIXTURES_PATH =  Pathname.new(__FILE__).dirname.join('fixtures')

    def with_basic_config

        RubyPack.config do | config |
            config.directory = FIXTURES_PATH
        end
        RubyPack::Configuration.generate
        yield
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

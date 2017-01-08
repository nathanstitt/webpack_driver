require_relative 'configuration/base'

module RubyPack

    module Configuration

        class << self

            def generate
                Base.start
            end

        end

    end

end

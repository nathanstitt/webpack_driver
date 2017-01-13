require_relative 'configuration/base'

module WebpackDriver

    module Configuration

        class << self

            def generate
                Base.start
            end

        end

    end

end

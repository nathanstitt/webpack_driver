require_relative 'configuration/base'

module WebpackDriver

    module Configuration

        class << self

            def generate

                Base.start# (verbose: false)
            end

        end

    end

end

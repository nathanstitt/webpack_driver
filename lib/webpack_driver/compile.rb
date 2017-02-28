module WebpackDriver

    class Compile < Process

        def initialize(config)
            config.environment ||= { NODE_ENV: 'production' }
            super('webpack', config)
        end

        def valid?
            !alive? && super
        end

    end

end

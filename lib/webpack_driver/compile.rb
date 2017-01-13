module WebpackDriver

    class Compile < Process

        def initialize(*flags)
            super(WebpackDriver.config.compile_script, *flags)
        end

        def valid?
            !alive? && super
        end

    end

end

module RubyPack

    class Compile < Process

        def initialize(*flags)
            super(RubyPack.config.compile_script, *flags)
        end

        def valid?
            !alive? && output.end_with?("[built]\n")
        end

    end

end

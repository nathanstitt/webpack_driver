module RubyPack

    class DevServer < Process

        def initialize(*flags)
            super(RubyPack.config.dev_server_script, *flags)
        end

        def valid?
            alive? && output.end_with?("VALID.\n")
        end

    end

end

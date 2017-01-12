module WebpackDriver


    class DevServer < Process
        URL = /(https?:\/\/)([\da-z\.-]+)\:(\d+)\/([\da-z\.-]+\/)?/

        def initialize(*flags)
            config = WebpackDriver.config
            flags = ['--port', config.port] if config.port
            super(config.dev_server_script, *flags)
        end

        def valid?
            alive? && output.end_with?("VALID.\n")
        end

        def detected_url
            match = URL.match(output)
            match ? match[0] : nil
        end

        def detected_port
            match = URL.match(output)
            match ? match[3].to_i : nil
        end

    end

end

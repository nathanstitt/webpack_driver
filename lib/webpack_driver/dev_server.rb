module WebpackDriver


    class DevServer < Process

        attr_reader :port, :host, :path

#        URL = /(https?:\/\/)([\da-z\.-]+)\:(\d+)\/([\da-z\.-]+\/)?/

        def initialize(*flags)

            config = WebpackDriver.config
            flags = ['--port', config.port] if config.port
            super(config.dev_server_script, *flags)
        end


        def valid?
            alive? && super
        end

        # def detected_url
        #     match = URL.match(output)
        #     match ? match[0] : nil
        # end

        # def detected_port

        #     match = URL.match(output)
        #     match ? match[3].to_i : nil
        # end

        private

        def record_message(msg)
            if msg['type'] == 'dev-server'
                @port = msg['value']['port']
                @host = msg['value']['host']
                @path = msg['value']['outputPath']
            end
            super
        end
    end

end

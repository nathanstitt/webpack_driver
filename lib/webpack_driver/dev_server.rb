module WebpackDriver

    # A wrapper around an instance of `webpak-dev-server`
    class DevServer < Process

        attr_reader :port, :host, :path

        def initialize(config)
            super('webpack-dev-server', config)
        end

        def valid?
            alive? && super
        end

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

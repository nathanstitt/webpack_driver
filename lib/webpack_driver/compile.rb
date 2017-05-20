require 'json'

module WebpackDriver

    class Compile < Process

        def initialize(config)
            config.environment ||= { NODE_ENV: 'production' }
            super('webpack', config)
            read_manifest
        end

        def valid?
            !alive? && complete? && last_status == 'success'
        end

        def complete?
            progress == 1
        end

        def record_progress(progress, msg)
            super
            write_manifest if complete?
        end

        def write_manifest
            manifest = {}
            assets.each do | id, asset |
                manifest[id] = asset.file
            end
            config.manifest_file.write JSON.generate manifest
        end

        def read_manifest
            return unless config.manifest_file.exist?
            manifest = JSON.parse config.manifest_file.read
            manifest.each do |id, file|
                asset = Asset.new({ 'id' => id, 'file' => file })
                assets[asset.id] = asset
            end
        end
    end
end

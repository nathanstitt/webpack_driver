module WebpackDriver

    class Asset

        attr_reader :id, :files, :size

        def initialize(attrs)
            @id   = attrs['id'].to_sym
            @size = attrs['size']
            @files = attrs['files']
        end

        def file
            files.first
        end

        def has_source_map?
            files.length > 1 && files.last.end_with?('.map')
        end

        def self.record(map, attrs)
            id = attrs['id'].to_sym
            map[id] = Asset.new(attrs)
        end
    end

end

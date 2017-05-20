module WebpackDriver

    class Asset

        attr_reader :id, :file, :size
        attr_accessor :has_source_map

        def initialize(attrs)
            @id   = attrs['id'].to_sym
            @size = attrs['size']
            @file = attrs['file']
        end

        def self.record(map, attrs)
            id = attrs['id'].to_sym
            file = attrs['file']
            if map[id] && file && file.end_with?('.map')
                map[id].has_source_map = true
            else
                map[id] = Asset.new(attrs)
            end
        end
    end

end

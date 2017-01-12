module WebpackDriver

    class Asset
        attr_reader :file, :size

        def initialize(file, size)
            @file = file
            @size = size
        end

    end

end

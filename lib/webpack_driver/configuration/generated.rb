require "thor"

module WebpackDriver

    class Configuration

        class Generated < Thor::Group
            include Thor::Actions

            class_option :config

            def self.source_root
                Pathname.new(__FILE__).dirname.join("..","..","..","templates")
            end

            def output
                template("generated.config.js", options[:config].path,  verbose: false, force: true)
            end

        end
    end
end

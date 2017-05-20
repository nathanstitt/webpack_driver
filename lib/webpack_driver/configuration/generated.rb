require "thor"

module WebpackDriver

    class Configuration

        class Generated < Thor::Group
            include Thor::Actions

            class_option :config

            attr_reader :config_directory, :path, :generated_directory

            def set_variables
                @generated_directory = options[:config].tmp_directory
                @config_directory = options[:config].file.dirname
                @path = generated_directory.join('generated.config.js')
            end

            def self.source_root
                Pathname.new(__FILE__).dirname.join("..","..","..","templates")
            end


            def output
                opts = { verbose: false, force: true }
                template(
                    options[:config].file.relative_path_from(self.class.source_root),
                    options[:config].tmp_directory.join('webpack.config.js'),
                    opts
                )
                template(
                    'generated.config.js',
                    path,
                    opts
                )
            end

        end
    end
end

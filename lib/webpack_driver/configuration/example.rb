require "thor"
require 'knitter'

module WebpackDriver

    class Configuration

        class Example < Thor::Group
            include Thor::Actions

            class_option :config

            attr_reader :yarn

            def self.source_root
                Pathname.new(__FILE__)
                        .dirname.join('..', '..', '..', 'templates')
            end

            def set_destination_root
                self.destination_root = options[:config].file.dirname
                @yarn = Knitter::Yarn.new(destination_root)
            end

            def install_using_yarn
                yarn.init unless yarn.valid?
                %w(webpack webpack-dev-server).each do |package|
                    package = Knitter::Package.new(package, yarn: yarn)
                    unless package.installed?
                        package.dependency_type = :development
                        package.add
                    end
                end
            end

            def generate
                template("webpack.config.js", verbose: false)
                template("index.js", verbose: false, force: true)
            end
        end
    end
end

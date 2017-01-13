require "thor"
require 'knitter'

module WebpackDriver

    module Configuration

        class Base < Thor::Group
            include Thor::Actions

            def self.source_root
                Pathname.new(__FILE__).dirname.join("..","..","..","templates")
            end

            def set_destination_root
                self.destination_root = WebpackDriver.config.directory
            end

            def install_using_yarn
                yarn = Knitter::Yarn.new(WebpackDriver.config.directory)
                yarn.init unless yarn.valid?
                %w{webpack webpack-dev-server}.each do | package |
                    package = Knitter::Package.new(package, yarn: yarn)
                    unless package.installed?
                        package.dependency_type = :development
                        package.add
                    end
                end
            end

            def generate
                template("webpack.config.js", verbose: false)
                template("status-plugin.js", verbose: false, force: true)
                template("index.js", verbose: false, force: true)
            end
        end

    end

end

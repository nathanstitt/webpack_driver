require "thor"
require 'knitter'

module RubyPack

    module Configuration

        class Base < Thor::Group
            include Thor::Actions
            quiet = true

            def self.source_root
                Pathname.new(__FILE__).dirname.join("..","..","..","templates")
            end

            def set_destination_root
                self.destination_root = RubyPack.config.directory
            end

            def yarn
                yarn = Knitter::Yarn.new(RubyPack.config.directory)
                unless RubyPack.config.directory.join('yarn.lock').exist?
                    yarn.init
                end
                %w{webpack webpack-dev-server}.each do | package |
                    package = Knitter::Package.new(package, yarn: yarn)
                    unless package.installed?
                        package.dependency_type = :development
                        package.add
                    end
                end
            end

            def generate
                template "webpack.config.js"
                template "index.js"
            end
        end

    end

end

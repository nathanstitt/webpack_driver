# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'webpack_driver/version'

Gem::Specification.new do |spec|
    spec.name          = "webpack_driver"
    spec.version       = WebpackDriver::VERSION
    spec.authors       = ["Nathan Stitt"]
    spec.email         = ["nathan@stitt.org"]

    spec.summary       = %q{Run webpack-dev-server in a sub process}
    spec.description   = %q{Run webpack and webpack-dev-server in a sub process}
    spec.homepage      = "https://github.com/nathanstitt/webpack_driver"
    spec.license       = "MIT"

    # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
    # to allow pushing to a single host or delete this section to allow pushing to any host.
    if spec.respond_to?(:metadata)
        spec.metadata['allowed_push_host'] = "https://rubygems.org"
    else
        raise "RubyGems 2.0 or newer is required to protect against " \
              "public gem pushes."
    end

    spec.files         = `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
    end
    spec.bindir        = "exe"
    spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
    spec.require_paths = ["lib"]

    spec.add_dependency 'knitter',      '~> 0.1'
    spec.add_dependency 'thor',         '~> 0.19'
    spec.add_dependency 'childprocess', '~> 0.5'

    spec.add_development_dependency "bundler",        "~> 1.13"
    spec.add_development_dependency "rake",           "~> 10.0"
    spec.add_development_dependency "guard",          "~> 2.13"
    spec.add_development_dependency "guard-minitest", "~> 2.3"
end

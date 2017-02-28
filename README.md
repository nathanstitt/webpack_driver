# WebpackDriver

[![Build Status](https://travis-ci.org/nathanstitt/webpack_driver.svg?branch=master)](https://travis-ci.org/nathanstitt/webpack_driver)

Control webpack from Ruby

WebpackDriver controls execution of both webpack and webpack-dev-server to serve assets in developer mode and to compile assets for production.

It runs the dev server in the background using the `childprocess` gem and monitors it's output to detect the current status.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webpack_driver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webpack_driver

## Usage

Initialization will create a `package.json`, `yarn.lock`, a bare-bones `webpack.config.js` and then run yarn install (via the [Knitter](https://github.com/nathanstitt/knitter) gem).

```ruby
config = WebpackDriver::Configuration.new('/path/to/my/webpack.config.js')
config.generate!
```

Production compilation:
```ruby
config = WebpackDriver::Configuration.new('/path/to/my/webpack.config.js')
compiler = WebpackDriver::Compile.new(config)
compiler.start
sleep 1 while compiler.alive?
p compiler.assets
```

Dev server:
```ruby
config = WebpackDriver::Configuration.new('/path/to/my/webpack.config.js', {
    port: 8333
})
server = WebpackDriver::DevServer.new(config)
server.start
fail("failed to start webpack #{server.output}") unless server.alive?

# wait for server to compile startup assets
sleep 1 until server.valid?

puts "Webpack dev server running on port #{server.port} url=#{server.url}"

p server.assets.map{|asset| asset.file }
sleep 30 # do other stuff
server.stop
fail("failed to stop webpack #{server.output}") if server.alive?

```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rb_webpack.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# RubyPack

Webpack integration for Ruby.  RubyWebpack controls execution of both webpack and webpack-dev-server to serve assets in developer mode and to compile assets for production.

It runs the dev server in the background using the `childprocess` gem and monitors it's output to detect the current status.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_pack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_pack

## Usage

Initialization, will create a `package.json`, `yarn.lock`, a bare-bones `webpack.config.js` and then run yarn install (via the [Knitter](https://github.com/nathanstitt/knitter) gem).

```ruby
RubyPack.config do | config |
  config.directory = '/tmp/test'
end
RubyPack::Configuration.generate
```

Production compilation (TODO):
```ruby
compiler = RubyPack::Compiler.new
compiler.generate
p compiler.files
```

Dev server:

```ruby
process = RubyPack::DevServer.new
process.start
fail("failed to start webpack #{process.output}") unless process.alive?
puts "Webpack dev server running on #{process.detected_port}"
sleep 30
process.stop
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rb_webpack.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

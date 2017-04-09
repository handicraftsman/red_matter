# RedMatter
Simple asset packer for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'red_matter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install red_matter

## Usage

Create file `Redfile` (other can be specified using `-f` option) with content like that:

```ruby
# Pack and minify all CSS and JS assets
asset 'vendor-js' do
  input Dir['vendor/js/*.js']
  output Dir['public/vendor.js'] do
    # Minify output here. Return result.
  end
end

asset 'vendor-css' do
  input Dir['vendor/css/*.css']
  output Dir['public/vendor.css'] do
    # Minify output here. Return result.
  end
end

# Pack and minify app's coffeescript file
asset 'app-coffeescript' do
  input 'app/app.coffee' do
    # Process coffeescript here. Output vanilla JS.
  end
  output Dir['public/app.js']
end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/handicraftsman/red_matter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


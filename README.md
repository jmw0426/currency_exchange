# CurrencyExchange

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/currency_exchange`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'currency_exchange'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install currency_exchange

## Usage

The Currency Exchange is a gem that parses exchange rates recognized by the European Central Bank from https://api.exchangeratesapi.io/ and utilizes that data in order to conduct exchanges between currencies. There are two modes. Default Mode only converts USD to into one of 32 currencies. Free Mode allows the user to select one out of 33 currencies to convert into another. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jmw0426/currency_exchange.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

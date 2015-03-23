# Updown

A wrapper for the Updown.io API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'updown'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install updown


## Configuration

Set your API key

```ruby
# config/initializers/updown.rb
Updown.configure do |config|
  config.api_key = 'your_api_key'
end
# or
Updown.configuration.api_key = 'your_api_key'
```

Or set the `UPDOWN_API_KEY` environment variable

## Usage

List all your checks:

```ruby
Updown::Check.all
```

See downtimes for a specific check:

```ruby
check.downtimes
```

Create a new check:

```ruby
Updown::Check.create 'https://google.com'
```

You can also set `period` and `published`:

```ruby
Updown::Check.create 'https://google.com', period: 30, published: true
```

Update a specific check:

```ruby
check.update period: 30
```

See more details about the options here: https://updown.io/api

Delete a specific check:

```ruby
check.destroy
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/updown/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

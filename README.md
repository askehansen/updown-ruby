# Updown

A Ruby wrapper and CLI for the [updown.io](https://updown.io) API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'updown'
```

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

Find your API key in your [settings page](https://updown.io/settings/edit).

## Usage

List all your checks:

```ruby
Updown::Check.all
# => [<Updown::Check>, <Updown::Check>, … ]
```

Retrieve a specific check:

```ruby
Updown::Check.get check_token
# => <Updown::Check>

# include performance metrics for the last hour
check = Updown::Check.get check_token, metrics: true
check.metrics
# => {"apdex": 0.98, "requests": { … }, "timings": { … }}
```

List downtimes for a specific check (paginated, 100 per call):

```ruby
check.downtimes
# => [<Updown::Downtime>, <Updown::Downtime>, … ]

check.downtimes page: 2
# => [<Updown::Downtime>]
```

Get detailed performance metrics for a specific check:

```ruby
# Default is for last month
check.get_metrics
# => {"apdex": 0.98, "requests": { … }, "timings": { … }}

# Specify time span
check.get_metrics from: 4.hours.ago, to: 2.hours.ago
# => {"apdex": 1, "requests": { … }, "timings": { … }}

# Specify grouping per location (:host) or hour (:time)
check.get_metrics group: :host
# => {
#   "sgp" => {"apdex": 0.82, "host": { city: "Singapore", … }, … },
#   "sfo" => {"apdex": 0.98, "host": { city: "San Francisco", … }, … },
#   "alpha" => {"apdex": 0.98, "host": { city: "Montreal", … }, … },
#   "gra" => {"apdex": 0.92, "host": { city: "Gravelines", … }, … }
# }
```

Create a new check:

```ruby
Updown::Check.create 'https://google.com'
# => <Updown::Check>
```

You can also set any parameters allowed by the API, like `enabled`, `published`, `period` or `apdex_t`:

```ruby
Updown::Check.create 'https://google.com', period: 30, published: true
# => <Updown::Check>
```

In case of validation errors, an `Updown::Error` will be raised:

```ruby
Updown::Check.create 'https://google.com', period: 45
# => Updown::Error: URL is already registered (given: "https://google.com"), Period is not included in the list (given: 45)
```

Update a specific check:

```ruby
check.update period: 30
# => <Updown::Check>
```

Delete a specific check:

```ruby
check.destroy
# => true
```

Learn more about the API here: https://updown.io/api

## Command Line

This gem also comes with an `updown` shell command.
First, configure your API key:

    $ updown configure YOUR_API_KEY

See the status of your checks:

    $ updown status
     [up]  rjis — https://google.com
    [DOWN] bn94 — https://bing.com
     [up]  qwer — http://stackoverflow.com

Open the status page of a check:

    $ updown open rjis

Add a new check:

    $ updown add https://google.com

## Todo

- Write tests!

## Contributing

1. Fork it ( https://github.com/askehansen/updown-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

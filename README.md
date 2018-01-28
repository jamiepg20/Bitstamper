This is a WIP, rewriting, refactoring and extending the original Bitstamp gem.

# Bitstamper Ruby API

Ruby client for interacting with Bitstamp. Originally inspired by the bitstamp gem but rewritten from the ground up and also includes additional API endpoints as well as websocket support.

Feel free to fork, modify & redistribute under the MIT license.

## Installation

Add this line to your application's Gemfile:

    gem 'bitstamper'

## Create API Key

More info at: [https://www.bitstamp.net/article/api-key-implementation/](https://www.bitstamp.net/article/api-key-implementation/)
    
## Setup

```ruby
Bitstamper.configure do |config|
  config.key = YOUR_API_KEY
  config.secret = YOUR_API_SECRET
  config.client_id = YOUR_BITSTAMP_USERNAME
end
```

If you fail to set your `key` or `secret` or `client_id` a `::Bitstamper::Errors::MissingConfigError`
will be raised.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b
my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request



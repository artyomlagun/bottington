# Bottington
Itexus bot framework that works with Telegram, Facebook Messenger, Viber(in future)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bottington'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bottington

## Configuration

Place .rb into the ```/config/initializers``` folder and configure framework like that:

```ruby
Bottington.setup do |config|
  config.telegram_token = 'TELEGRAM_TOKEN_HERE'

  config.facebook_token = 'FACEBOOK_TOKEN_HERE'
  config.fb_verify_token = 'verify'

  config.route_prefix = '/bottington'
end
```
After that you should place Bottington routes into ```/config/routes.rb```:

```ruby
Rails.application.routes.draw do
  # HERE YOUR OTHER ROUTES

  # Below routes for bots
  post '/bottington/telegram/pizza', to: 'bot_requests#telegram_pizza'
  post '/bottington/facebook/pizza', to: 'bot_requests#facebook_pizza'

  post '/bottington/telegram/coffee', to: 'bot_requests#telegram_coffee'
end

Bottington.routes.draw do
  platform :telegram, :facebook do
    map '/pizza', PizzaBot
  end

  platform :telegram do
    map '/coffee', CoffeeBot
  end
end
```

And in the end you write your own Bot like that:

```ruby
class PizzaBot < Bottington::BaseBot
  def call
    # generate some response for bot
    reply(:text, response, @request)
  end
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

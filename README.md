# Paymium::Api

Simple ruby client to interract with the [paymium.com API](https://github.com/Paymium/api-documentation)

Work in progress

## Installation

Add this line to your application's Gemfile:

    gem 'paymium_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paymium_api

## Usage

```ruby
@client = Paymium::Api::Client.new  host: 'https://paymium.com/api/v1', 
                                    key: "you api token", 
                                    secret: "your api secret"

@client.get('/data/EUR/ticker')

@client.get('/user')
````

## TODO
- test merchants API
- Dev oAuth api points
- Better error management

## Contributing

1. Fork it ( http://github.com/<my-github-username>/paymium_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

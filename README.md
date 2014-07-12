# Messente::Rails

Messente.com API wrapper for Rails (non official)

Original API documentation: [https://messente.com/docs/api/rest/](https://messente.com/docs/api/rest/)

## Installation

Add this line to your application's Gemfile:

    gem 'messente-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install messente-rails

Then you should run install generator:

    $ rails g messente_rails:install
    
You should review the generated file and at least insert your credentials.

NB! Don't forget to restart server after configuration.

## Usage

Methods from original documentation as is, but only synchronous sending is supported for now.

Original API documentation: [https://messente.com/docs/api/rest/](https://messente.com/docs/api/rest/)

## Contributing

1. Fork it ( https://github.com/Gedrovits/messente-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

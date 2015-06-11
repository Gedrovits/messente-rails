# messente-rails

Non-official [Messente.com](https://messente.com) SMS gateway API wrapper for Rails.
Original API documentation: [https://messente.com/documentation/setup-and-activation](https://messente.com/documentation/setup-and-activation)

[![Gem Version](https://badge.fury.io/rb/messente-rails.svg)](http://badge.fury.io/rb/messente-rails)
[![Build Status](https://travis-ci.org/Gedrovits/messente-rails.svg)](https://travis-ci.org/Gedrovits/messente-rails)
[![Dependency Status](https://gemnasium.com/Gedrovits/messente-rails.svg)](https://gemnasium.com/Gedrovits/messente-rails)
[![Code Climate](https://codeclimate.com/github/Gedrovits/messente-rails.png)](https://codeclimate.com/github/Gedrovits/messente-rails)
[![Inline docs](http://inch-ci.org/github/Gedrovits/messente-rails.png?branch=master)](http://inch-ci.org/github/Gedrovits/messente-rails)

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

Original API documentation: [https://messente.com/documentation/setup-and-activation](https://messente.com/documentation/setup-and-activation)

Idea was to leave original API names intact, so methods and parameters from API are same in gem.

So for example to send SMS with generated initializer it's simply as that:

    $ messente = Messente.new
    $ messente.send_sms(text: 'Message', to: '+000000000')

OR alternative way

    $ Messente.send_sms(text: 'Message', to: '+000000000')

This way you can pass in required and optional parameters and use official documentation as manual.

    $ Messente.prices(country: 'GB', format: 'xml')
    
NB! Be warned about non-ruby like attribute names and pass them as strings. 
For now there is only one parameter like this 'dlr-url'. Please if you need it send it like that:

    $ Messente.send_sms(text: 'Message', to: '+000000000', 'dlr-url' => 'http://example.com/callback')

## Contributing

1. Fork it ( https://github.com/Gedrovits/messente-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

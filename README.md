# SpringCM SDK

[![Gem Version](https://badge.fury.io/rb/springcm-sdk.svg)](https://badge.fury.io/rb/springcm-sdk) [![Depfu](https://badges.depfu.com/badges/d19cc9a4361b84a276e21997c49e640e/overview.svg)](https://depfu.com/github/paulholden2/springcm-sdk?project_id=10385) [![Build Status](https://travis-ci.org/paulholden2/springcm-sdk.svg?branch=master)](https://travis-ci.org/paulholden2/springcm-sdk) [![Maintainability](https://api.codeclimate.com/v1/badges/06e1dd90fde417de15da/maintainability)](https://codeclimate.com/github/paulholden2/springcm-sdk/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/06e1dd90fde417de15da/test_coverage)](https://codeclimate.com/github/paulholden2/springcm-sdk/test_coverage)

This gem is a library for working with the SpringCM REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'springcm-sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install springcm-sdk

## Usage

### Connecting

To begin using the SpringCM REST API, you must first acquire a client ID and
secret pair. To do so, contact DocuSign Support and request a key pair for
REST API usage. They require you to be a super administrator in the account
before they will generate the key pair for you. For more information, see
the [SpringCM REST API Guide].

```ruby
client = Springcm::Client.new("uatna11", "<your client ID>", "<your client secret>")
client.connect
client.authenticated?
# ...
```

For more information, view the [documentation].

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/paulholden2/springcm-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[SpringCM REST API Guide]: https://developer.springcm.com/guides/rest-api-guide
[documentation]: https://rubydoc.info/github/paulholden2/springcm-sdk

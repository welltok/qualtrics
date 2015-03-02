# Qualtrics

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'qualtrics'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qualtrics

Qualtrics.configure do |config|
  config.user = ENV['QUALTRICS_USER']
  config.token = ENV['QUALTRICS_TOKEN']
  config.default_library_id = ENV['QUALTRICS_LIBRARY_ID']
end

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/qualtrics/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

require 'rspec'
require 'pry'
require 'qualtrics'

Qualtrics.configure do |config|
  config.user = ENV['QUALTRICS_USER']
  config.token = ENV['QUALTRICS_TOKEN']
end

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

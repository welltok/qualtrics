require 'rspec'
require 'pry'
require 'qualtrics'
require 'mocha/api'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
	config.mock_with :mocha
end
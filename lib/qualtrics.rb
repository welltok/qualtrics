require 'configatron'

require "qualtrics/configuration"
require "qualtrics/version"
require "qualtrics/response"
require "qualtrics/recipient"
require "qualtrics/panel"

module Qualtrics
  def self.configure(&block)
    configuration.update(&block)
  end

  def self.configuration
    if !configatron.has_key?(:qualtrics)
      configatron.qualtrics = Configuration.new
    end
    configatron.qualtrics
  end

  class Error < StandardError; end
  class ServerErrorEncountered < Error; end
  class UpdateNotAllowed < Error; end
  class UnexpectedRequestMethod < Error; end
end

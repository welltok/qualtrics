require 'configatron'

require "qualtrics/configuration"
require "qualtrics/version"
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

end

require 'configatron'

require "qualtrics/configuration"
require "qualtrics/version"
require "qualtrics/operation"
require "qualtrics/operation_v3"
require "qualtrics/response"
require "qualtrics/entity"
require "qualtrics/recipient"
require "qualtrics/panel"
require "qualtrics/panel_import"
require "qualtrics/survey"
require "qualtrics/survey_import"
require "qualtrics/division"
require "qualtrics/division_user"

require "qualtrics/message"
require "qualtrics/distribution"
require "qualtrics/submission"
require "qualtrics/mailer"

# not always necessary for runtime
# consider adding only when necessary
require "qualtrics/transaction"

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

  class << self
    def begin_transaction!
      configatron.qualtrics_transaction = Qualtrics::Transaction.new
      Qualtrics::Operation.add_listener(configatron.qualtrics_transaction)
    end

    def rollback_transaction!
      if configatron.has_key?(:qualtrics_transaction)
        configatron.qualtrics_transaction.rollback!
        Qualtrics::Operation.delete_listener(configatron.qualtrics_transaction)
      end
    end
  end

  class Error < StandardError; end
  class ServerErrorEncountered < Error; end
  class UpdateNotAllowed < Error; end
  class UnexpectedRequestMethod < Error; end
  class UnexpectedContentType < Error; end
end

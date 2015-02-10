require 'active_support/time'
require 'active_model/validations'

module Qualtrics
  class Mailer < Entity
    include ActiveSupport
    include ActiveModel::Validations

    attr_accessor :send_date, :from_email, :from_name, :subject
    validates :send_date, presence: true
    validates :from_email, presence: true
    validates :from_name, presence: true
    validates :subject, presence: true

    QUALTRICS_POST_TIMEZONE = "Mountain Time (US & Canada)"

    def initialize(options={})
      @send_date = options[:send_date] || post_time
      @from_email = options[:from_email]
      @from_name = options[:from_name]
      @subject = options[:subject]
    end

    def send_to_individual(recipient, message, survey)
      return false if !valid?

      response = post('sendSurveyToIndividual', attributes.merge(
        {
          'RecipientID' => recipient.id,
          'MessageID' => message.id,
          'SurveyID' => survey.id,
          'MessageLibraryID' => library_id,
          'PanelID' => recipient.panel_id,
          'PanelLibraryID' => library_id
        })
      )

      response.success?
    end

    def attributes
      {
        'SendDate'  => send_date,
        'FromEmail' => from_email,
        'FromName'  => from_name,
        'Subject'   => subject
      }
    end

    private
    def post_time
      formatted_time Time.now.utc.in_time_zone(QUALTRICS_POST_TIMEZONE)
    end

    def formatted_time(time)
      time.strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
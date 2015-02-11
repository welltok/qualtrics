module Qualtrics
  class Distribution < Entity

    include ActiveModel::Validations

    validates :id, presence: true
    validates :message_id, presence: true
    validates :survey_id, presence: true

    attr_accessor :id, :survey_id, :message_id,
                  :emails_sent, :emails_failed, :emails_responded,
                  :emails_bounced, :emails_opened, :emails_skipped

    def initialize(options={})
      @id = options[:id]
      @message_id = options[:message_id]
      @survey_id = options[:survey_id]
      set_email_response_data(options)
    end

    def set_email_response_data(options={})
      @emails_sent      = options[:emails_sent]
      @emails_failed    = options[:emails_failed]
      @emails_responded = options[:emails_responded]
      @emails_bounced   = options[:emails_bounced]
      @emails_opened    = options[:emails_opened]
      @emails_skipped   = options[:emails_skipped]
    end

    def self.attributes
      {
        'EmailDistributionID'   => :id,
        'MessageID'             => :message_id,
        'SurveyID'              => :survey_id,
        'EmailsSent'            => :emails_sent,
        'EmailsFailed'          => :emails_failed,
        'EmailsResponded'       => :emails_responded,
        'EmailsBounced'         => :emails_bounced,
        'EmailsOpened'          => :emails_opened,
        'EmailsSkipped'         => :emails_skipped
      }
    end

    def refresh
      response = get('getDistributions',
        {
          'SurveyID' => survey_id,
          'DistributionID' => id,
          'LibraryID' => library_id
        }
      )

      if response.success?
        distribution_hash = response.result['Distributions']
        set_email_response_data(self.class.response_hash(distribution_hash ))
        true
      else
        false
      end
    end

    def self.get_distribution_with_panel(panel, survey, library_id = configuration.default_library_id)
      response = get('getDistributions',
        {
          'SurveyID' => survey.id,
          'PanelID' => panel.id,
          'LibraryID' => library_id
        }
      )

      if response.success?
        response.result['Distributions'].map do |distribution|
          Qualtrics::Distribution.new(response_hash(distribution))
        end
      else
        false
      end
    end

    private

    def self.response_hash(distribution_response)
      {}.tap do |result|
        attributes.each do |k,v|
          result[v] = distribution_response[k]
        end
      end.delete_if {|key, value| value.nil? }
    end
  end
end
module Qualtrics
  class Submission < Entity

    attr_accessor :id, :survey_id, :distribution_id, :finished_survey, :time_stamp

    def initialize(options={})
      @id = options[:id]
      @survey_id = options[:survey_id]
      @distribution_id = options[:distribution_id]
      @finished_survey = options[:finished_survey]
      @time_stamp = options[:time_stamp]
    end

    def info_hash
      response = get('getLegacyResponseData', {
        'SurveyID' => survey_id,
        'ResponseID' => id,
        'Format' => 'CSV',
        'ExportTags' => 1
      })

      if response.success?
        response
      else
        false
      end
    end

    def self.attribute_map
      {
        'ResponseID' => :id,
        'SurveyID' => :survey_id,
        'TimeStamp' => :time_stamp,
        'EmailDistributionID' => :distribution_id,
        'FinishedSurvey' => :finished_survey
      }
    end
  end
end
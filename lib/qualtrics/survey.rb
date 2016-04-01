require 'faraday'
require 'faraday_middleware'
require 'json'

module Qualtrics
  class Survey < Entity
    attr_accessor :responses, :id, :survey_name,
                  :survey_owner_id, :survey_status, :survey_start_date,
                  :survey_expiration_date, :survey_creation_date,
                  :creator_id, :last_modified, :last_activated,
                  :user_first_name, :user_last_name, :status,
                  :questions

    def initialize(options={})
      @responses = options[:responses]
      @id = options[:id]
      @survey_name = options[:survey_name]
      @survey_owner_id = options[:survey_owner_id] || options[:owner_id]
      @survey_status = options[:survey_status] || options[:is_active]
      @survey_start_date = options[:survey_start_date] || options[:start_date]
      @survey_expiration_date = options[:survey_expiration_date] || options[:expiration_date]
      @survey_creation_date = options[:survey_creation_date] || options[:creation_date]
      @creator_id = options[:creator_id] || options[:owner_id]
      @last_modified = options[:last_modified] || options[:last_modified_date]
      @last_activated = options[:last_activated]
      @user_first_name = options[:user_first_name]
      @user_last_name = options[:user_last_name]
      @questions = options[:questions]
    end

    def status
      @status = case survey_status
      when '1'
        'Active'
      when '0'
        'Inactive'
      else
        survey_status
      end
    end

    def self.all(options={library_id: nil})
      lib_id = options[:library_id] || configuration.default_library_id
      response = get('getSurveys', {'LibraryID' => lib_id})
      if response.success?
        response.result['Surveys'].map do |survey|
          new(underscore_attributes(survey))
        end
      else
        []
      end
    end

    def self.find(id)
      response = get('getSurvey', {'SurveyID' => id})
      if response.success?
        attributes = underscore_attributes(response.result['SurveyDefinition']).merge({id: id})
        new(attributes)
      else
        nil
      end
    end

    def retrieve_all_raw_responses(start_date, end_date, format = 'CSV')
      response = get('getLegacyResponseData', {
        'SurveyID' => id,
        'StartDate' => formatted_time(start_date),
        'EndDate' => formatted_time(end_date),
        'Format' => format,
        'ExportQuestionIDs' => 1
      })

      if response.status == 200
        response.result
      else
        false
      end
    end

    def self.attribute_map
      {
        'responses' => :responses,
        'SurveyID' => :id,
        'SurveyName' => :survey_name,
        'SurveyOwnerID' => :survey_owner_id,
        'OwnerID' => :owner_id,
        'SurveyStatus' => :survey_status,
        'isActive' => :is_active,
        'SurveyStartDate' => :survey_start_date,
        'StartDate' => :start_date,
        'SurveyExpirationDate' => :survey_expiration_date,
        'ExpirationDate' => :expiration_date,
        'SurveyCreationDate' => :survey_creation_date,
        'CreationDate' => :creation_date,
        'CreatorID' => :creator_id,
        'LastModified' => :last_modified,
        'LastModifiedDate' => :last_modified_date,
        'LastActivated' => :last_activated,
        'UserFirstName' => :user_first_name,
        'UserLastName' => :user_last_name,
        'Questions' => :questions
      }
    end

    def destroy
      response = post('deleteSurvey', {
        'SurveyID' => id
      })
      response.success?
    end

    def activate
      response = post('activateSurvey', {
        'SurveyID' => id
      })
      response.success?
    end

    def deactivate
      response = post('deactivateSurvey', {
        'SurveyID' => id
      })
      response.success?
    end

    def response_count
      response = get('getResponseCountsBySurvey', {
        'SurveyID' => id,
        'StartDate' => Time.parse(survey_creation_date).strftime('%Y-%m-%d'),
        'EndDate' => Time.now.strftime('%Y-%m-%d'),
        'Format' => 'JSON'
      })

      if response.status == 200
        response.result
      else
        nil
      end
    end
  end
end

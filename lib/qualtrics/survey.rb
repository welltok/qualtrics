require 'faraday'
require 'faraday_middleware'
require 'json'

module Qualtrics
  class Survey < Entity
    attr_accessor :responses, :survey_id, :survey_name,
                  :survey_owner_id, :survey_status, :survey_start_date,
                  :survey_expiration_date, :survey_creation_date,
                  :creator_id, :last_modified, :last_activated,
                  :user_first_name, :user_last_name
    #
    # def self.all(library_id = nil)
    #   lib_id = library_id || configuration.default_library_id
    #   response = get('getPanels', {'LibraryID' => lib_id})
    #   if response.success?
    #     response.result['Panels'].map do |panel|
    #       new(underscore_attributes(panel))
    #     end
    #   else
    #     []
    #   end
    # end

    def self.attribute_map
      {
        'responses' => :responses,
        'SurveyID' => :survey_id,
        'SurveyName' => :survey_name,
        'SurveyOwnerID' => :survey_owner_id,
        'SurveyStatus' => :survey_status,
        'SurveyStartDate' => :survey_start_date,
        'SurveyExpirationDate' => :survey_expiration_date,
        'SurveyCreationDate' => :survey_creation_date,
        'CreatorID' => :creator_id,
        'LastModified' => :last_modified,
        'LastActivated' => :last_activated,
        'UserFirstName' => :user_first_name,
        'UserLastName' => :user_last_name
      }
    end
    #
    # def initialize(options={})
    #   @name = options[:name]
    #   @id = options[:id]
    #   @category = options[:category]
    #   @library_id = options[:library_id]
    # end
    #
    #
    # def destroy
    #   response = post('deletePanel', {
    #     'LibraryID' => library_id,
    #     'PanelID' => self.id
    #   })
    #   response.success?
    # end
    #
    # def attributes
    #   {
    #     'LibraryID' => library_id,
    #     'Category' => category,
    #     'Name' => name
    #   }
    # end
  end
end

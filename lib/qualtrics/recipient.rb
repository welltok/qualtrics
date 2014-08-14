module Qualtrics
  class Recipient < Entity
    attr_accessor :email, :first_name, :last_name, :language, :external_data, :embedded_data, :unsubscribed, :panel_id

    # qualtrics_attribute :library_id, 'LibraryID'

    def initialize(options={})
      @email = options[:email]
      @first_name = options[:first_name]
      @last_name = options[:last_name]
      @language = options[:language]
      @external_data = options[:external_data]
      @embedded_data = options[:embedded_data]
      @unsubscribed = options[:unsubscribed]

      @panel_id = options[:panel_id]
    end

    def attributes
      {
          'LibraryID'        => library_id,
          'PanelID'          => panel_id,
          'Email'            => email,
          'FirstName'        => first_name,
          'LastName'         => last_name,
          'ExternalDataRef'  => external_data,
          'Language'         => language,
          'ED'               => embedded_data,
          'Unsubscribed'     => unsubscribed
      }
    end

    def save
      if !@panel_id.nil?
        response = post('addRecipient', attributes)

        if response.success?
          true
        else
          false
        end
      else
        raise Qualtrics::MissingPanelID
      end
    end

    def self.attribute_map
      {
        'LibraryID'        => :library_id,
        'PanelID'          => :panel_id,
        'Email'            => :email,
        'FirstName'        => :first_name,
        'LastName'         => :last_name,
        'ExternalDataRef'  => :external_data,
        'Language'         => :language,
        'ED'               => :embedded_data,
        'Unsubscribed'     => :unsubscribed
      }
    end
  end
end

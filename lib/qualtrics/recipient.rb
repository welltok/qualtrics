module Qualtrics
  class Recipient < Entity
    attr_accessor :email, :first_name, :last_name, :language, :external_data, :embedded_data, :unsubscribed, :panel_id, :id

    # qualtrics_attribute :library_id, 'LibraryID'

    def initialize(options={})
      set_attributes(options)
      @panel_id = options[:panel_id]
      @id = options[:id]
    end

    def set_attributes(options={})
      @email = options[:email]
      @first_name = options[:first_name]
      @last_name = options[:last_name]
      @language = options[:language]
      @external_data = options[:external_data]
      @embedded_data = options[:embedded_data]
      @unsubscribed = options[:unsubscribed]
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
      }.delete_if {|key, value| value.nil? }
    end

    def save
      if !@panel_id.nil?
        response = post('addRecipient', attributes)

        if response.success?
          self.id = response.result['RecipientID']
          true
        else
          false
        end
      else
        raise Qualtrics::MissingPanelID
      end
    end

    def info_hash
      response = get('getRecipient', {'LibraryID' => library_id, 'RecipientID' => id})
      if response.success? && !response.result['Recipient'].nil?
        response.result['Recipient']
      else
        false
      end
    end

    def update(options={})
      set_attributes(options)
      response = post('updateRecipient', update_params)

      if response.success?
        true
      else
        false
      end
    end

    def delete
      response = post('removeRecipient', {
          'LibraryID' => library_id,
          'RecipientID' => id,
          'PanelID' => panel_id
      })

      if response.success?
        true
      else
        false
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

    protected
    def update_params
      {
          'LibraryID' => library_id,
          'RecipientID' => id
      }.merge(attributes)
    end
  end
end

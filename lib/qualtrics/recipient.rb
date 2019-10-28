module Qualtrics
  class Recipient < Entity
    attr_accessor :directory_id, :email, :first_name, :last_name, :language, :external_data, :embedded_data, :unsubscribed, :panel_id, :id
    validates :panel_id, presence: true
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
      if Qualtrics.configuration.migrated_to_version_3?
        {
          'email'            => email,
          'firstName'        => first_name,
          'lastName'         => last_name,
          'externalDataRef'  => external_data,
          'language'         => language,
          'embeddedData'     => embedded_data,
          'unsubscribed'     => unsubscribed
        }.delete_if {|key, value| value.nil? }
      else
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
    end

    def panel=(panel)
      self.panel_id = panel.id
    end

    def save
      return false if !valid?
      if Qualtrics.configuration.migrated_to_version_3?
        save_v3
      else
        save_v2
      end
    end

    def save_v3
      Qualtrics.configuration.logger.info("addRecipient attributes #{attributes}")
      response = post("/API/v3/mailinglists/#{panel_id}/contacts/", attributes)

      if response.success?
        self.id = response.result['id']
        Qualtrics.configuration.logger.info("addRecipient response #{response.result}")
        true
      else
        false
      end
    end

    def save_v2
      Qualtrics.configuration.logger.info("addRecipient attributes #{attributes}")
      response = post('addRecipient', attributes)

      if response.success?
        self.id = response.result['RecipientID']
        Qualtrics.configuration.logger.info("addRecipient response #{response.result}")
        true
      else
        false
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

    def response_history
      info_hash["RecipientResponseHistory"].map do |r|
        response = Hash[r.map{|k,v| [Qualtrics::Submission.attribute_map[k], v]}]
        Qualtrics::Submission.new(response)
      end
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

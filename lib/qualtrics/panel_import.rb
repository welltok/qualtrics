require "qualtrics/panel_import_file"

module Qualtrics
  class PanelImport < Entity
    attr_accessor :panel, :recipients

    def initialize(options={})
      @panel = options[:panel]
      @recipients = options[:recipients]
    end

    def save
      payload = headers
      payload['LibraryID'] = library_id
      payload['ColumnHeaders'] = 1
      file = Qualtrics::PanelImportFile.new(@recipients)
      payload['Data'] = Faraday::UploadIO.new(file.temp_file, 'text/csv')
      post 'importPanel', payload
      true
    end

    def headers
      {}.tap do |import_headers|
        Qualtrics::RecipientImportRow.fields.each_with_index.map do |field, index|
          import_headers[self.class.attributes[field]] = index + 1
        end
      end
    end

    def self.attributes
      {
        'email' => 'Email',
        'first_name' => 'FirstName',
        'last_name' => 'LastName',
        'external_ref' => 'ExternalRef',
        'unsubscribed' =>'Unsubscribed',
        'language' => 'Language'
      }
    end
  end
end
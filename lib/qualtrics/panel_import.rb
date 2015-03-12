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
      payload['PanelID'] = @panel.id if @panel.persisted?
      file = Qualtrics::PanelImportFile.new(@recipients)
      post 'importPanel', payload, File.read(file.temp_file)
      true
    end

    def headers
      {}.tap do |import_headers|
        Qualtrics::RecipientImportRow.fields.each_with_index.map do |field, index|
          import_headers[field] = index + 1
        end
      end
    end
  end
end

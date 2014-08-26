require 'tempfile'
require 'csv'
require 'qualtrics/recipient_import_row'

module Qualtrics
  class PanelImportFile
    attr_reader :recipients

    def initialize(recipients)
      @recipients = recipients
    end

    def temp_file
      if @temp_file.nil?
        tmp_file = Tempfile.new('panel_import')
        csv_path = tmp_file.path
        tmp_file.close
        CSV.open(csv_path, 'wb', :force_quotes => true, :write_headers => true, :headers => Qualtrics::RecipientImportRow.fields) do |csv|
          @recipients.each do |recipient|
            csv << Qualtrics::RecipientImportRow.new(recipient).to_a
          end
        end
        @temp_file = csv_path
      end
      @temp_file
    end
  end
end
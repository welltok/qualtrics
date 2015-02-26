require 'spec_helper'

describe Qualtrics::PanelImportFile do
  let(:email) { 'user@example.com' }
  let(:recipients) {[Qualtrics::Recipient.new(email: email), Qualtrics::Recipient.new] }
  let(:panel_import_file) do
    Qualtrics::PanelImportFile.new(recipients)
  end

  it 'has a list of recipients' do
    expect(panel_import_file.recipients).to eql(recipients)
  end

  it 'writes a temp file' do
    expect(panel_import_file.temp_file).to_not be_nil
    expect(FileTest.exists?(panel_import_file.temp_file)).to be true
  end

  it 'contains a header' do
    expect(File.read(panel_import_file.temp_file)).to include("FirstName")
  end

  it 'contains a row of recipients' do
    expect(File.read(panel_import_file.temp_file)).to include(email)
  end
end
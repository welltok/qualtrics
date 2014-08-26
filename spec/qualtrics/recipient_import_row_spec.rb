require 'spec_helper'

describe Qualtrics::RecipientImportRow do
  let(:email) { 'fake@fake.com' }
  let(:first_name) { 'Johnny' }
  let(:last_name) { 'Fakesalot' }
  let(:external_data) { '1234' }
  let(:embedded_data) { '4567' }
  let(:unsubscribed) { 0 }
  let(:language) { 'EN' }
  let(:recipient) do
    Qualtrics::Recipient.new({
      email: email,
      first_name: first_name,
      last_name: last_name,
      external_data: external_data,
      embedded_data: embedded_data,
      unsubscribed: unsubscribed,
      language: language
    })
  end
  let(:recipient_row) do
    Qualtrics::RecipientImportRow.new(recipient)
  end

  it 'has a recipient' do
    expect(recipient_row.recipient).to eql(recipient)
  end

  def index(field)
    Qualtrics::RecipientImportRow.fields.index(field)
  end

  it 'returns email in the correct spot' do
    expect(recipient_row.to_a[index('email')]).to eql(email)
  end

  it 'returns the first_name in the correct spot' do
    expect(recipient_row.to_a[index('first_name')]).to eql(first_name)
  end

  it 'returns the last_name in the correct spot' do
    expect(recipient_row.to_a[index('last_name')]).to eql(last_name)
  end

  it 'returns the external_data in the correct spot' do
    expect(recipient_row.to_a[index('external_data')]).to eql(external_data)
  end

  it 'returns the embedded_data in the correct spot' do
    expect(recipient_row.to_a[index('embedded_data')]).to eql(embedded_data)
  end
  it 'returns unsubscribed in the correct spot' do
    expect(recipient_row.to_a[index('unsubscribed')]).to eql(unsubscribed)
  end

  it 'returns language in the correct spot' do
    expect(recipient_row.to_a[index('language')]).to eql(language)
  end


end
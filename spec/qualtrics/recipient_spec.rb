require 'spec_helper'

describe Qualtrics::Recipient do
	it 'has an email' do
    email = 'example@example.com'

    recipient = Qualtrics::Recipient.new({
      email: email
    })
    expect(recipient.email).to eql(email)
  end

	it 'has a first name' do
    first_name = 'Peter'

    recipient = Qualtrics::Recipient.new({
      first_name: first_name
    })
    expect(recipient.first_name).to eql(first_name)
  end

	it 'has a last name' do
    last_name = 'Johnson'

    recipient = Qualtrics::Recipient.new({
      last_name: last_name
    })
    expect(recipient.last_name).to eql(last_name)
  end

	it 'has a language' do
    language = 'en'

    recipient = Qualtrics::Recipient.new({
      language: language
    })
    expect(recipient.language).to eql(language)
  end

  it 'has an external data reference' do
    external_data = '11'

    recipient = Qualtrics::Recipient.new({
      external_data: external_data
    })
    expect(recipient.external_data).to eql(external_data)
  end

  it 'has embedded data' do
    embedded_data = 'recipient_id:1290-38'

    recipient = Qualtrics::Recipient.new({
      embedded_data: embedded_data
    })
    expect(recipient.embedded_data).to eql(embedded_data)
  end

  it 'has an unsubscribed attribute' do
    unsubscribed = false

    recipient = Qualtrics::Recipient.new({
      unsubscribed: unsubscribed
    })
    expect(recipient.unsubscribed).to eql(unsubscribed)
  end
end
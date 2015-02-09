require 'spec_helper'

describe Qualtrics::Message, vcr: true do
  it 'has a name' do
    name = 'New message'
    message = Qualtrics::Message.new({
      name: name
    })
    expect(message.name).to eq(name)
  end

  it 'has a category' do
    category = 'InviteEmails'
    message = Qualtrics::Message.new({
      category: category
    })
    expect(message.category).to eq(category)
  end

  it 'only accepts valid categories' do
    category = 'Not real category'
    message = Qualtrics::Message.new({
      category: category
    })

    expect(message.save).to be false
    expect(message.errors[:category]).to_not be_blank
  end

  it 'has a body' do
    body = 'Hi take my survey'
    message = Qualtrics::Message.new({
      body: body
    })
    expect(message.body).to eq(body)
  end

  it 'has a language' do
    language = 'FR'
    message = Qualtrics::Message.new({
      language: language
    })
    expect(message.language).to eq(language)
  end

  it 'defaults to the configured language when none is specified' do
    message = Qualtrics::Message.new
    expect(message.language).to eq('EN')
  end

  it 'has a library id' do
    library_id = '1'
    message = Qualtrics::Message.new({
      library_id: library_id
    })
    expect(message.library_id).to eq(library_id)
  end

  it 'defaults to the configured library id when none is specified' do
    message = Qualtrics::Message.new
    expect(message.library_id).to eq(Qualtrics.configuration.default_library_id)
  end

  let(:message) do
    Qualtrics::Message.new({
      name: 'Newest Message',
      category: 'InviteEmails',
      body: 'Welcome'
    })
  end

  context 'creating to qualtrics' do
    # before(:each) do
    #   Qualtrics.begin_transaction!
    # end
    #
    # after(:each) do
    #   Qualtrics.rollback_transaction!
    # end

    it 'persists to qualtrics' do
      expect(message.save).to be true
    end

    it 'populates the message_id when successful' do
      message.save
      expect(message.id).to_not be_nil
    end

    it 'populates the success attribute' do
      message.save
      expect(message).to be_success
    end
  end

  # it 'destroys a message that returns true when successful' do
  #   message.save
  #   expect(message.destroy).to be true
  # end

  it 'retrieves an array of all panels in a library' do
    message.save
    expect(Qualtrics::Message.all.map{|m| m.id}).to include(message.id)
  end
end
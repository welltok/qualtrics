require 'spec_helper'

describe Qualtrics::Recipient, :vcr => true  do
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
    unsubscribed = 1

    recipient = Qualtrics::Recipient.new({
      unsubscribed: unsubscribed
    })
    expect(recipient.unsubscribed).to eql(unsubscribed)
  end

  it 'has a panel id' do
    panel_id = 1

    recipient = Qualtrics::Recipient.new({
      panel_id: panel_id
    })
    expect(recipient.panel_id).to eql(panel_id)
  end

  it 'has a recipient id' do
    id = 1

    recipient = Qualtrics::Recipient.new({
      id: id
    })
    expect(recipient.id).to eql(id)
  end

  it 'defaults to the configured library id when none is specified' do
    recipient = Qualtrics::Recipient.new
    expect(recipient.library_id).to eq(Qualtrics.configuration.default_library_id)
  end

  let(:panel) do
    Qualtrics::Panel.new({
      name: 'Newest Panel',
      category: 'Great Category'
    })
  end

  let(:recipient) do
    Qualtrics::Recipient.new({
      panel_id: panel.id
    })
  end

  context 'creating to qualtrics' do
    before(:each) do
      Qualtrics.begin_transaction!
      panel.save
    end

    after(:each) do
      Qualtrics.rollback_transaction!
    end

    it 'persists to qualtrics' do
      expect(recipient.save).to be true
    end

    it 'populates the recipient id when successful' do
      recipient.save
      expect(recipient.id).to_not be_nil
    end

    it 'populates the success attribute' do
      recipient.save
      expect(recipient).to be_success
    end

    it 'raises an error when a recipient is created without specifying a panel id' do
      recipient = Qualtrics::Recipient.new
      expect(recipient.save).to be false
      expect(recipient.errors[:panel_id]).to_not be_blank
    end
  end

  context 'recipient made in qualtrics' do
    before(:each) do
      Qualtrics.begin_transaction!
      panel.save
    end

    after(:each) do
      Qualtrics.rollback_transaction!
    end

    it 'gets its information in qualtrics' do
      first_name = 'Kevin'

      recipient = Qualtrics::Recipient.new({
        panel_id: panel.id,
        first_name: first_name
      })
      recipient.save

      expect(recipient.info_hash['FirstName']).to include(recipient.first_name)
    end

    it 'can update itself in qualtrics' do
      first_name = 'Kevin'
      new_name = 'Ben'

      recipient = Qualtrics::Recipient.new({
        panel_id: panel.id,
        first_name: first_name
      })
      recipient.save

      attributes = {
        first_name: new_name
      }
      recipient.update(attributes)

      expect(recipient.update(attributes)).to be true
      expect(recipient.first_name).to eql(new_name)
      expect(recipient.info_hash['FirstName']).to include(new_name)
    end

    it 'can delete itself in qualtrics' do
      recipient.save

      expect(recipient.info_hash['PanelID']).to include(panel.id)
      recipient.delete
      expect(recipient.info_hash).to be false
    end
  end

  context 'has responses' do
    let(:recipient) { Qualtrics::Recipient.new }

    it 'can check its own response history' do
      allow(recipient).to receive(:info_hash).and_return (
        {
          'PanelMemberID' => 'whatever',
          'PanelID' => 'this is',
          'FirstName' => 'kk',
          'LastName' => 'omg',
          'RecipientResponseHistory' =>
            [{'ResponseID' => 'response_id',
              'SurveyID' => 'survey_id',
              'TimeStamp' => '2015-03-02 11:50:40',
              'EmailDistributionID' => 'distribution_id',
              'FinishedSurvey' => true}]
        }
      )

      response = recipient.response_history[0]
      expect(response.distribution_id).to eql('distribution_id')
      expect(response.finished_survey).to eql(true)
      expect(response.id).to eql('response_id')
      expect(response.survey_id).to eql('survey_id')
      expect(response.time_stamp).to eql('2015-03-02 11:50:40')
    end
  end
end
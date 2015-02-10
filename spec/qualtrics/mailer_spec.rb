require 'spec_helper'

describe Qualtrics::Mailer, :vcr do

  it 'has a send date' do
    send_date = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    mailer = Qualtrics::Mailer.new({
      send_date: send_date
    })
    expect(mailer.send_date).to eq(send_date)
  end

  it 'has a default send date' do
    send_date = Time.now.utc.in_time_zone(Qualtrics::Mailer::QUALTRICS_POST_TIMEZONE).strftime("%Y-%m-%d %H:%M:%S")
    mailer = Qualtrics::Mailer.new({})
    expect(mailer.send_date).to eq(send_date)
  end

  it 'has a from email' do
    from_email = 'having_fun@isnthard.com'
    mailer = Qualtrics::Mailer.new({
      from_email: from_email
    })
    expect(mailer.from_email).to eq(from_email)
  end

  it 'has a from name' do
    from_name = 'Pinkberry'
    mailer = Qualtrics::Mailer.new({
      from_name: from_name
    })
    expect(mailer.from_name).to eq(from_name)
  end

  it 'has a subject' do
    subject = 'party invitation'
    mailer = Qualtrics::Mailer.new({
      subject: subject
    })
    expect(mailer.subject).to eq(subject)
  end

  let(:panel) do
    Qualtrics::Panel.new({
      name: 'Newest Panel',
      category: 'Great Category'
    })
  end

  let(:recipient) do
    Qualtrics::Recipient.new({
      panel_id: panel.id,
      email: 'working@hard.com'
    })
  end

  let(:message) do
    Qualtrics::Message.new({
      name: 'Newest Message',
      category: 'InviteEmails',
      body: 'Welcome'
    })
  end

  let(:survey_import) do
    survey_import = Qualtrics::SurveyImport.new({
      survey_name: 'Complex survey',
      survey_data_location: 'spec/fixtures/sample_survey.xml'
    })
  end

  let(:survey) { survey_import.survey }

  context 'creating to qualtrics' do
    before(:each) do
      panel.save
      recipient.save
      survey_import.save
      message.save
    end

    after(:each) do
      recipient.delete
      panel.destroy
      survey.destroy
    end

    it 'sends a survey to an individual' do
      from_email = 'example@example.com'
      from_name = 'yes_qualtrics'
      subject = 'game convention'

      mailer = Qualtrics::Mailer.new({
        from_email: from_email,
        from_name: from_name,
        subject: subject
      })

      response = mailer.send_to_individual(recipient, message, survey)
      expect(response).to be true
    end
  end
end
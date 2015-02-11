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

  it 'has a sent from email' do
    sent_from_address = 'sent_here@gmail.com'
    mailer = Qualtrics::Mailer.new({
      sent_from_address: sent_from_address
    })
    expect(mailer.sent_from_address).to eq(sent_from_address)
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
    let(:from_name) { 'yes_qualtrics' }
    let(:from_email) { 'example@example.com' }
    let(:subject) { 'game convention' }
    let(:mailer) do
      mailer = Qualtrics::Mailer.new({
        from_email: from_email,
        from_name: from_name,
        subject: subject
      })
    end

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

    it 'sends a survey to an individual and creates a distribution' do
      qualtrics_distribution = mailer.send_survey_to_individual(recipient, message, survey)
      expect(qualtrics_distribution.survey_id).to equal(survey.id)
      expect(qualtrics_distribution.id).to_not be_nil
    end

    it 'sends a reminder to a distribution' do
      qualtrics_distribution = mailer.send_survey_to_individual(recipient, message, survey)
      reminder_distribution = mailer.send_reminder(qualtrics_distribution, message)
      expect(reminder_distribution.survey_id).to equal(survey.id)
      expect(reminder_distribution.id).to_not be_nil
    end

    it 'sends a survey to a panel and creates a distribution' do
      qualtrics_distribution = mailer.send_survey_to_panel(panel, message, survey)
      expect(qualtrics_distribution.survey_id).to equal(survey.id)
      expect(qualtrics_distribution.id).to_not be_nil
    end
  end
end
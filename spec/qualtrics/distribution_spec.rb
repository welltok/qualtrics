require 'spec_helper'

describe Qualtrics::Distribution, vcr: true do
  it 'has a id' do
    id = 'JOASNDOANSd'
    distribution = Qualtrics::Distribution.new({
      id: id
    })
    expect(distribution.id).to eq(id)
  end

  it 'has a survey id' do
    survey_id = 'survey123'
    distribution = Qualtrics::Distribution.new({
     survey_id: survey_id
    })
    expect(distribution.survey_id).to eq(survey_id)
  end

  it 'has a message id' do
    message_id = 'message123'
    distribution = Qualtrics::Distribution.new({
      message_id: message_id
    })
    expect(distribution.message_id).to eq(message_id)
  end

  it 'has response data' do
    emails_sent      = '1'
    emails_failed    = '2'
    emails_responded = '3'
    emails_bounced   = '4'
    emails_opened    = '5'
    emails_skipped   = '6'

    distribution = Qualtrics::Distribution.new({
      emails_sent: emails_sent,
      emails_failed: emails_failed,
      emails_responded: emails_responded,
      emails_bounced: emails_bounced,
      emails_opened: emails_opened,
      emails_skipped: emails_skipped
    })

    expect(distribution.emails_sent).to eq(emails_sent)
    expect(distribution.emails_failed).to eq(emails_failed)
    expect(distribution.emails_responded).to eq(emails_responded)
    expect(distribution.emails_bounced).to eq(emails_bounced)
    expect(distribution.emails_opened).to eq(emails_opened)
    expect(distribution.emails_skipped).to eq(emails_skipped)
  end

  context 'creating to qualtrics' do
    let(:panel) do
      Qualtrics::Panel.new({
        name: 'Newest Panel',
        category: 'Great Category'
      })
    end

    let(:survey_import) do
      survey_import = Qualtrics::SurveyImport.new({
        survey_name: 'Complex survey',
        survey_data_location: 'spec/fixtures/sample_survey.xml'
      })
    end

    let(:survey) { survey_import.survey }


    let(:recipient) do
      Qualtrics::Recipient.new({
        panel_id: panel.id,
        email: 'working@hard.com'
      })
    end

    let(:recipient2) do
      Qualtrics::Recipient.new({
        panel_id: panel.id,
        email: 'notworking@hard.com'
      })
    end

    let(:message) do
      Qualtrics::Message.new({
        name: 'Newest Message',
        category: 'InviteEmails',
        body: 'Welcome'
      })
    end

    let(:mailer) do
      mailer = Qualtrics::Mailer.new({
        from_email: 'example@example.com',
        from_name: 'yes_qualtrics',
        subject: 'game convention'
      })
    end

    before(:each) do
      panel.save
      recipient.save
      recipient2.save
      survey_import.save
      message.save
    end

    after(:each) do
      recipient.delete
      recipient2.delete
      panel.destroy
      survey.destroy
    end

    it 'can retrieve a panel of distributions in qualtrics' do
      mailer.send_survey_to_individual(recipient, message, survey)
      mailer.send_survey_to_individual(recipient2, message, survey)

      distributions = Qualtrics::Distribution.get_distribution_with_panel(panel, survey)
      expect(distributions.length).to eql (2)

      first_distribution = distributions[0]
      expect(first_distribution.survey_id).to eql (survey.id)

      expect(first_distribution.valid?).to be true
      expect(first_distribution.emails_responded).to_not be_nil
      expect(first_distribution.emails_sent     ).to_not be_nil
      expect(first_distribution.emails_failed   ).to_not be_nil
      expect(first_distribution.emails_responded).to_not be_nil
      expect(first_distribution.emails_bounced  ).to_not be_nil
      expect(first_distribution.emails_opened   ).to_not be_nil
      expect(first_distribution.emails_skipped  ).to_not be_nil
    end

    it 'can update itself' do
      distribution = mailer.send_survey_to_individual(recipient, message, survey)
      expect(distribution.emails_responded).to be_nil

      expect(distribution.refresh).to be true
      expect(distribution.emails_responded).to_not be_nil
    end
  end
end
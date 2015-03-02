require 'spec_helper'

describe Qualtrics::Submission, vcr: true do
  it 'has an id' do
    id = '12345asdfg'

    submission = Qualtrics::Submission.new({
      id: id
    })

    expect(submission.id).to eql(id)
  end

  it 'has a survey id' do
    survey_id = 'survey_id'

    submission = Qualtrics::Submission.new({
      survey_id: survey_id
    })

    expect(submission.survey_id).to eql(survey_id)
  end

  it 'has a distribution id' do
    distribution_id = 'distribution_id'

    submission = Qualtrics::Submission.new({
      distribution_id: distribution_id
    })

    expect(submission.distribution_id).to eql(distribution_id)
  end

  it 'has a finished survey boolean' do
    finished_survey = true

    submission = Qualtrics::Submission.new({
      finished_survey: finished_survey
    })

    expect(submission.finished_survey).to eql(finished_survey)
  end

  it 'has a timestamp' do
    time_stamp = "2015-03-02 11:50:40"

    submission = Qualtrics::Submission.new({
      time_stamp: time_stamp
    })

    expect(submission.time_stamp).to eql(time_stamp)
  end

end
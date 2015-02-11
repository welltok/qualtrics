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


end

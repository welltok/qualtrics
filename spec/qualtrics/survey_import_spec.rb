require 'spec_helper'

describe Qualtrics::SurveyImport, :vcr => true  do
  it 'has a survey name' do
    survey_name = 'great name'
    survey_import = Qualtrics::SurveyImport.new({
      survey_name: survey_name
    })
    expect(survey_import.survey_name).to eql(survey_name)
  end

  it 'has a survey' do
    survey_name = 'great name'
    survey_import = Qualtrics::SurveyImport.new({
      survey_name: survey_name
    })
    expect(survey_import.survey_name).to eql(survey_import.survey.survey_name)
  end

  it 'has survey file location' do
    survey_data_location = 'some location'

    survey_import = Qualtrics::SurveyImport.new({
      survey_data_location: survey_data_location
    })
    expect(survey_import.survey_data_location).to eql(survey_data_location)
  end

  it 'transmits to qualtrics' do
    survey_data_location = 'spec/fixtures/sample_survey.xml'

    survey = Qualtrics::Survey.new({
      survey_name: 'Newest Survey'
    })

    survey_import = Qualtrics::SurveyImport.new({
      survey_data_location: survey_data_location,
      survey: survey
    })

    expect(survey_import.save).to be true
    survey_import.survey.destroy
  end
end
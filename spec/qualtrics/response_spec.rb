require 'spec_helper'

describe Qualtrics::Response, :vcr do
	# it 'has a body' do

	# end
  let(:test_endpoint) do
    Faraday.new do |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |m|
        m.get('/success') { |env| [ 200, {'Content-Type'=>'application/json'}, '{"Meta":{"Status":"Success","Debug":""},"Result":{"PanelID":"ML_8BKIZdmCic6tkLb"}}' ]}
        m.get('/server_error') { |env| [500, {'Content-Type'=>'application/json'}, '']}
        m.get('/server_error2') { |env| [400, {'Content-Type'=>'application/json'}, '{"Meta":{"Status":"Fubar","Debug":"","ErrorMessage":"Invalid request. Missing or invalid parameter RecipientID."}}']}
        m.get('/failure') { |env| [ 200, {'Content-Type'=>'application/json'}, '{"Meta":{"Status":"Fubar","Debug":""}}' ]}
      end
    end
  end

  it 'is successful when the meta status is success' do
    raw_response = test_endpoint.get('/success')
    response = Qualtrics::Response.new(raw_response)
    expect(response).to be_success
  end

  it 'is not successful when the meta status is not success' do
    raw_response = test_endpoint.get('/failure')
    response = Qualtrics::Response.new(raw_response)
    expect(response).to_not be_success
  end

  it 'has a result hash' do
    raw_response = test_endpoint.get('/success')
    response = Qualtrics::Response.new(raw_response)
    expect(response.result).to be_kind_of(Hash)
    expect(response.status).to eql(200)
  end

  it 'raises an exception when a 5xx error is received' do
    raw_response = test_endpoint.get('/server_error')
    expect(lambda{ Qualtrics::Response.new(raw_response)}).to raise_error(Qualtrics::ServerErrorEncountered)
  end

  it 'raises a error message when a 4xx error is received' do
    raw_response = test_endpoint.get('/server_error2')

    begin
      response = Qualtrics::Response.new(raw_response)
      expect(response.status).to eql(400)
    rescue Qualtrics::ServerErrorEncountered => e
      expect(e.message).to eql('Invalid request. Missing or invalid parameter RecipientID.')
    end
  end

  context 'parsing different content types' do
    let(:content_endpoints) do
      Faraday.new do |builder|
        builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |m|
          m.get('/csv_response') { |env| [ 200, {'Content-Type'=>'application/vnd.msexcel'}, 'csv,stuff' ]}
          m.get('/json_response') { |env| [ 200, {'Content-Type'=>'application/json'}, '{"Meta":{"Status":"Fubar","Debug":""}}' ]}
          m.get('/random_content') { |env| [ 200, {'Content-Type'=>'random stuff'}, 'not a real body' ]}
        end
      end
    end

    it 'can parse csv' do
      # s = Qualtrics::Submission.new(id: 'R_5msAm76fXKn1adf', survey_id:'SV_8deJytTY3InclQ9')
      raw_response = content_endpoints.get('/csv_response')
      response = Qualtrics::Response.new(raw_response)
      expect(lambda{ response.send(:body) }).to_not raise_error
    end

    it 'can parse json' do
      # s = Qualtrics::Submission.new(id: 'R_5msAm76fXKn1adf', survey_id:'SV_8deJytTY3InclQ9')
      raw_response = content_endpoints.get('/json_response')
      response = Qualtrics::Response.new(raw_response)
      expect(lambda{ response.send(:body) }).to_not raise_error
    end

    it 'raises an error for other content types' do
      # s = Qualtrics::Submission.new(id: 'R_5msAm76fXKn1adf', survey_id:'SV_8deJytTY3InclQ9')
      raw_response = content_endpoints.get('/random_content')
      response = Qualtrics::Response.new(raw_response)
      expect(lambda{ response.send(:body) }).to raise_error(Qualtrics::UnexpectedContentType)
    end
  end
end

require 'spec_helper'

describe Qualtrics::Response, :vcr do
	# it 'has a body' do

	# end
  let(:test_endpoint) do
    Faraday.new do |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |m|
        m.get('/success') { |env| [ 200, {}, '{"Meta":{"Status":"Success","Debug":""},"Result":{"PanelID":"ML_8BKIZdmCic6tkLb"}}' ]}
        m.get('/server_error') { |env| [500, {}, '']}
        m.get('/failure') { |env| [ 200, {}, '{"Meta":{"Status":"Fubar","Debug":""}}' ]}
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
  end

  it 'raises an exception when a 5xx error is received' do
    raw_response = test_endpoint.get('/server_error')
    expect(lambda{ Qualtrics::Response.new(raw_response)}).to raise_error(Qualtrics::ServerErrorEncountered)
  end


end

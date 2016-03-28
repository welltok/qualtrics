require 'spec_helper'

describe Qualtrics::Configuration do
  it 'has a version' do
    version = '2.3'
    configuration = Qualtrics::Configuration.new do |config|
      config.version = version
    end
    expect(configuration.version).to eq(version)
  end

  it 'defaults to latest version' do
    configuration = Qualtrics::Configuration.new
    expect(configuration.version).to eq(Qualtrics::Configuration::DEFAULT_VERSION)
  end

  it 'has a user' do
    user = 'fake@example.com'
    configuration = Qualtrics::Configuration.new do |config|
      config.user = user
    end
    expect(configuration.user).to eq(user)
  end

  it 'has a token' do
    token = '12341234'
    configuration = Qualtrics::Configuration.new do |config|
      config.token = token
    end
    expect(configuration.token).to eq(token)
  end

  it 'has an endpoint' do
    endpoint = 'https://co1.qualtrics.com/WRAPI/ControlPanel/api.php'
    configuration = Qualtrics::Configuration.new do |config|
      config.endpoint = endpoint
    end
    expect(configuration.endpoint).to eq(endpoint)
  end

  it 'has a default endpoint' do
    configuration = Qualtrics::Configuration.new
    expect(configuration.endpoint).to eq(Qualtrics::Configuration::DEFAULT_ENDPOINT)
  end

  it 'has a default library id' do
    library_id = 1
    configuration = Qualtrics::Configuration.new do |config|
      config.default_library_id = library_id
    end
    expect(configuration.default_library_id).to eql(library_id)
  end

  it 'has a organization' do
    organization = 'brand'
    configuration = Qualtrics::Configuration.new do |config|
      config.organization = organization
    end
    expect(configuration.organization).to eq(organization)
  end
end
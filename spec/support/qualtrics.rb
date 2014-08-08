Qualtrics.configure do |config|
  config.user = ENV['QUALTRICS_USER']
  config.token = ENV['QUALTRICS_TOKEN']
  config.default_library_id = ENV['QUALTRICS_LIBRARY_ID']
end

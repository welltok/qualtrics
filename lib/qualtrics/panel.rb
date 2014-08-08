require 'faraday'
require 'faraday_middleware'

module Qualtrics
  class Panel
    attr_accessor :name, :category, :library_id

    def initialize(options={})
      @name = options[:name]
      @category = options[:category]
      @library_id = options[:library_id]
    end

    def library_id
      @library_id || configuration.default_library_id
    end

    def save
      post('createPanel', attributes)
    end

    def attributes
      {
        'LibraryID' => library_id,
        'Category' => category,
        'Name' => name
      }
    end

    protected

    def post(request, options={})
      body = options.dup.merge(default_params)
      body['Request'] = request
      resp = connection.post(path, body)
    end

    def path
      '/WRAPI/ControlPanel/api.php'
    end

    def connection
      @connection ||= Faraday.new(:url => 'https://survey.qualtrics.com') do |faraday|
        faraday.request  :url_encoded
        faraday.use ::FaradayMiddleware::FollowRedirects, limit: 3
        faraday.adapter Faraday.default_adapter
      end
    end

    def default_params
      {
        'User' => configuration.user,
        'Token' => configuration.token,
        'Version' => configuration.version,
        'Format' => 'JSON'
      }
    end

    def configuration
      Qualtrics.configuration
    end
  end
end
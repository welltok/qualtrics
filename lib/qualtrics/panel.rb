require 'faraday'
require 'faraday_middleware'
require 'json'

module Qualtrics
  class Panel
    attr_accessor :id, :name, :category, :library_id

    def initialize(options={})
      @name = options[:name]
      @category = options[:category]
      @library_id = options[:library_id]
    end

    def library_id
      @library_id || configuration.default_library_id
    end

    def save
      response = post('createPanel', attributes)

      if response.success?
        self.id = response.result['PanelID']
      end
      !self.id.nil?
    end

    def attributes
      {
        'LibraryID' => library_id,
        'Category' => category,
        'Name' => name
      }
    end

    def success?
      @last_response && @last_response.success?
    end

    protected

    def post(request, options={})
      body = options.dup.merge(default_params)
      body['Request'] = request
      @last_response = Qualtrics::Response.new(connection.post(path, body))
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

module Qualtrics
  class OperationV3
    attr_reader :http_method, :action, :options, :entity_name, :command, :payload, :path, :headers
    REQUEST_METHOD_WHITELIST = [:get, :post]
    CONTENT_TYPE_JSON = 'application/json'
    @@listeners = []

    def initialize(http_method, path, payload, body_override = nil)
      @http_method = http_method
      @action = path
      @path = path
      @options = payload
      @payload = options
      @entity_name = nil
      @body_override = body_override
      @command = $1
    end

    def issue_request
      raise Qualtrics::UnexpectedRequestMethod if !REQUEST_METHOD_WHITELIST.include?(http_method)

      puts "starting call to: #{http_method} #{path}"
      response = connection.public_send(http_method, path, payload) do |req|
        # req.options.timeout = config.http_timeout # add in timeout option?
        req.headers['Content-Type'] = CONTENT_TYPE_JSON
        req.headers['Accept'] = CONTENT_TYPE_JSON
        req.headers['X-API-TOKEN'] = configuration.token
        puts "with headers: #{req.headers}"

        req.body = payload.to_json if payload.present?
      end

      puts response.status
      puts response.body
      Qualtrics::Response.new(response)
    end

    protected

    def connection
      @connection ||= Faraday.new(url: configuration.endpoint) do |faraday|
        faraday.request  :url_encoded
        faraday.use ::FaradayMiddleware::FollowRedirects, limit: 3
        faraday.adapter Faraday.default_adapter
      end
    end

    def configuration
      Qualtrics.configuration
    end
  end
end

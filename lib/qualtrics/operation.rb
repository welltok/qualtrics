module Qualtrics
  class Operation
    attr_reader :http_method, :action, :options, :entity_name, :command
    REQUEST_METHOD_WHITELIST = [:get, :post]
    @@listeners = []

    def initialize(http_method, action, options)
      @http_method = http_method
      @action = action
      @options = options
      @entity_name = action.gsub(/(create|delete|update)/, '')
      @command = $1
    end

    def issue_request
      raise Qualtrics::UnexpectedRequestMethod if !REQUEST_METHOD_WHITELIST.include?(http_method)

      body = options.dup.merge(default_params)
      body['Request'] = action

      Qualtrics::Response.new(connection.send(http_method, path, body)).tap do |response|
        if !@listeners_disabled
          @@listeners.each do |listener|
            listener.received_response(self, response)
          end
        end
      end
    end

    def disable_listeners(&block)
      @listeners_disabled = true
      block.call(self)
      @listeners_disabled = nil
    end

    class << self
      def add_listener(listener)
        @@listeners << listener
      end

      def delete_listener(listener)
        @@listeners.delete(listener)
      end

      def flush_listeners!
        @@listeners = []
      end
    end

    protected
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
module Qualtrics
  class Configuration
    attr_accessor :version, :user, :token, :library_id, :endpoint, :default_library_id, :organization, :logger
    DEFAULT_VERSION = '2.3'
    DEFAULT_ENDPOINT = 'https://co1.qualtrics.com/WRAPI/ControlPanel/api.php'
    DEFAULT_API_TOKEN = 'default_api_token'

    def initialize(&block)
      block.call(self) if block_given?

      self.version ||= DEFAULT_VERSION
      self.endpoint ||= DEFAULT_ENDPOINT
      self.logger  ||= begin
                         logger = Logger.new(STDOUT)
                         logger.level = Logger::INFO
                         logger
                       end
    end

    def migrated_to_version_3?
      version.to_f >= 3
    end

    def update(&block)
      block.call(self) if block_given?
    end
  end
end

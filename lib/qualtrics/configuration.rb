module Qualtrics
  class Configuration
    attr_accessor :version, :user, :token, :library_id, :endpoint, :default_library_id, :organization
    DEFAULT_VERSION = '2.3'
    DEFAULT_ENDPOINT = 'https://co1.qualtrics.com/WRAPI/ControlPanel/api.php'

    def initialize(&block)
      block.call(self) if block_given?
      self.version ||= DEFAULT_VERSION
      self.endpoint ||= DEFAULT_ENDPOINT
    end

    def update(&block)
      block.call(self) if block_given?
    end
  end
end

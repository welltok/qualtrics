require 'active_model'
require "qualtrics/operation_v3"

module Qualtrics
  class Entity
    include ActiveModel::Model
    include ActiveModel::Validations

    QUALTRICS_POST_TIMEZONE = 'Mountain Time (US & Canada)'

    def library_id=(lib_id)
      @library_id = lib_id
    end

    def library_id
      @library_id || configuration.default_library_id
    end

    def success?
      @last_response && @last_response.success?
    end

    def persisted?
      !id.nil?
    end

    def post(request, options = {}, body_override = nil)
      @last_response = self.class.post(request, options, body_override)
    end

    def get(request, options = {})
      @last_response = self.class.get(request, options)
    end

    def configuration
      self.class.configuration
    end

    def self.underscore_attributes(attributes)
      attribute_map.inject({}) do |map, keys|
        qualtrics_key, ruby_key = keys[0], keys[1]
        map[ruby_key] = attributes[qualtrics_key]
        map
      end
    end

    def self.post(request, options = {}, body_override = nil)
      qualtrics_api_operation.new(:post, request, options, body_override).issue_request
    end

    def self.get(request, options = {})
      qualtrics_api_operation.new(:get, request, options).issue_request
    end

    def self.qualtrics_api_operation
      if configuration.migrated_to_version_3?
        Qualtrics::OperationV3
      else
        Qualtrics::Operation
      end
    end

    def self.configuration
      Qualtrics.configuration
    end

    def formatted_time(time)
      time.utc.in_time_zone(QUALTRICS_POST_TIMEZONE).strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end

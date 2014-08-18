require 'active_model'
module Qualtrics
  class Entity
    include ActiveModel::Model
    include ActiveModel::Validations

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

    def post(request, options = {})
      @last_response = self.class.post(request, options)
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

    def self.post(request, options = {})
      Qualtrics::Operation.new(:post, request, options).issue_request
    end

    def self.get(request, options = {})
      Qualtrics::Operation.new(:get, request, options).issue_request
    end

    def self.configuration
      Qualtrics.configuration
    end
  end
end
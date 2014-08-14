require 'faraday'
require 'faraday_middleware'
require 'json'

module Qualtrics
  class Panel
    attr_accessor :id, :name, :category, :library_id

    def self.all(library_id = nil)
      lib_id = library_id || configuration.default_library_id
      response = get('getPanels', {'LibraryID' => lib_id})
      if response.success?
        response.result['Panels'].map do |panel|
          new(underscore_attributes(panel))
        end
      else
        []
      end
    end

    def self.underscore_attributes(attributes)
      attribute_map.inject({}) do |map, keys|
        qualtrics_key, ruby_key = keys[0], keys[1]
        map[ruby_key] = attributes[qualtrics_key]
        map
      end
    end

    def self.attribute_map
      {
        'LibraryID' => :library_id,
        'Category' => :category,
        'Name' => :name,
        'PanelID' => :id
      }
    end

    def initialize(options={})
      @name = options[:name]
      @id = options[:id]
      @category = options[:category]
      @library_id = options[:library_id]
    end

    def library_id
      @library_id || configuration.default_library_id
    end

    def save
      response = nil
      if persisted?
        raise Qualtrics::UpdateNotAllowed
      else
        response = post('createPanel', attributes)
      end

      if response.success?
        self.id = response.result['PanelID']
        true
      else
        false
      end
    end

    def destroy
      response = post('deletePanel', {
        'LibraryID' => library_id,
        'PanelID' => self.id
        })
      response.success?
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

    def persisted?
      !id.nil?
    end

    def post(request, options = {})
      @last_response = self.class.post(request, options)
    end

    def get(request, options = {})
      @last_response = self.class.get(request, options)
    end

    def self.post(request, options = {})
      Qualtrics::Operation.new(:post, request, options).issue_request
    end

    def self.get(request, options = {})
      Qualtrics::Operation.new(:get, request, options).issue_request
    end

    def configuration
      self.class.configuration
    end

    def self.configuration
      Qualtrics.configuration
    end
  end
end

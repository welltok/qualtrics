require 'faraday'
require 'faraday_middleware'
require 'json'

module Qualtrics
  class Panel < Entity
    attr_accessor :id, :name, :category

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

    def add_recipients(recipients)
      panel_import = Qualtrics::PanelImport.new({
          panel: self,
          recipients: recipients
      })
      panel_import.save
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
  end
end

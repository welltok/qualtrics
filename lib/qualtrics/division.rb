module Qualtrics
  class Division < Entity
    attr_accessor :id, :name

    def initialize(options = {})
      @name = options[:name]
    end
    
    def create
      response = post('createDivision', {
        'Name' => name
      })

      if response.success?
        self.id = response.result
        true
      else
        false
      end      
    end
  end
end
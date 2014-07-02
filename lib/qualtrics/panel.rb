module Qualtrics
  class Panel
    attr_accessor :name, :category, :library_id

    def initialize(options={})
      @name = options[:name]
      @category = options[:category]
      @library_id = options[:library_id]
    end
  end
end
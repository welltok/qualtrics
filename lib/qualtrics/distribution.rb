module Qualtrics
  class Distribution < Entity

    include ActiveModel::Validations

    validates :id, presence: true
    validates :survey_id, presence: true

    attr_accessor :id, :survey_id

    def initialize(options={})
      @id = options[:id]
      @survey_id = options[:survey_id]
    end
  end
end
module Qualtrics
  class Recipient
    attr_accessor :email, :first_name, :last_name, :language, :external_data, :embedded_data, :unsubscribed

    def initialize(options={})
      @email = options[:email]
      @first_name = options[:first_name]
      @last_name = options[:last_name]
      @language = options[:language]
      @external_data = options[:external_data]
      @embedded_data = options[:embedded_data]
      @unsubscribed = options[:unsubscribed]
    end
  end
end

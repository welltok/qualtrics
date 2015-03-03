require 'json'
require 'csv'

module Qualtrics
	class Response

    def initialize(raw_response)
      @raw_response = raw_response
      if status != 200
        raise Qualtrics::ServerErrorEncountered, error_message
      end
    end

    def success?
      body['Meta'].nil? ? false : body['Meta']['Status'] == 'Success'
    end

    def result
      if content_type == 'application/vnd.msexcel'
        body.nil? ? {} : body
      else
        body['Result'].nil? ? {} : body['Result']
      end
    end

    def status
      @raw_response.status
    end

    protected

    def body
      if @body.nil?
        if @raw_response.body == ''
          @body = {}
        elsif content_type == 'application/json'
          @body = JSON.parse(@raw_response.body)
        elsif content_type == 'application/vnd.msexcel'
          @body = @raw_response.body
        else
          raise Qualtrics::UnexpectedContentType, content_type
        end
      end
      @body
    end

    def content_type
      if @content_type.nil?
        header = @raw_response.headers['Content-Type']
        if header.nil?
          @content_type = {}
        else
          @content_type = header
        end
      end
      @content_type
    end

    private
    def error_message
      body['Meta'].nil? ? 'No error message' : body['Meta']['ErrorMessage']
    end
  end
end


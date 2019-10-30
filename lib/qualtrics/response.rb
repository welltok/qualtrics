require 'json'
require 'csv'
require 'nokogiri'
require 'active_support/core_ext/hash/conversions'

module Qualtrics
  class Response

    SUCCESS_STATUSES = %w(200)
    def initialize(raw_response)
      @raw_response = raw_response
      if status != 200
        raise Qualtrics::ServerErrorEncountered, error_message
      end
    end

    def success?
      if Qualtrics.configuration.migrated_to_version_3?
        v3_success?
      else
        v2_success?
      end
    end

    def v3_success?
      body['meta'].present? && SUCCESS_STATUSES.any? { |status| body['meta']['httpStatus'].match(status) }
    end

    def v2_success?
      case format
      when 'XML'
        !body.nil?
      else
        body['Meta'].nil? ? false : body['Meta']['Status'] == 'Success'
      end
    end

    def format
      case content_type
      when 'application/vnd.msexcel'
        'CSV'
      when 'application/json'
        'JSON'
      when 'text/xml'
        'XML'
      end
    end

    def result
      case content_type
      when 'application/vnd.msexcel'
        body.nil? ? {} : body
      when 'application/json'
        json_result
      when 'text/xml'
        body.nil? ? '' : body
      else
        body['Result'].nil? ? {} : body['Result']
      end
    end

    def status
      @raw_response.status
    end

    protected

    def json_result
      if Qualtrics.configuration.migrated_to_version_3?
        body['result'].nil? ? (body || {}) : body['result']
      else
        body['Result'].nil? ? (body.nil? ? {} : body) : body['Result']
      end
    end

    def body
      if @body.nil?
        if @raw_response.body == ''
          @body = {}
        elsif content_type == 'application/json'
          @body = JSON.parse(@raw_response.body)
        elsif content_type == 'application/vnd.msexcel'
          @body = @raw_response.body
        elsif content_type == 'text/xml'
          @body = Hash.from_xml(Nokogiri::XML(@raw_response.body).to_xml)
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
      if Qualtrics.configuration.migrated_to_version_3?
        body['meta'].nil? ? 'No error message' : body.dig('meta', 'error', 'errorMessage')
      else
        body['Meta'].nil? ? 'No error message' : body['Meta']['ErrorMessage']
      end
    end
  end
end


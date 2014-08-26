module Qualtrics
  class RecipientImportRow
    attr_reader :recipient

    def initialize(recipient)
      @recipient = recipient
    end

    def to_a
      self.class.fields.map do |field|
        field_map[field]
      end
    end

    def field_map
      {
        'first_name'    => recipient.first_name,
        'last_name'     => recipient.last_name,
        'email'         => recipient.email,
        'embedded_data' => recipient.embedded_data,
        'external_data' => recipient.external_data,
        'unsubscribed'  => recipient.unsubscribed,
        'language'      => recipient.language
      }
    end
    class << self
      def fields
        [
          'first_name',
          'last_name',
          'email',
          'embedded_data',
          'external_data',
          'unsubscribed',
          'language'
        ]
      end
    end
  end
end

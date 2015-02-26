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
        'FirstName'    => recipient.first_name,
        'LastName'     => recipient.last_name,
        'Email'         => recipient.email,
        'EmbeddedData' => recipient.embedded_data,
        'ExternalData' => recipient.external_data,
        'Unsubscribed'  => recipient.unsubscribed,
        'Language'      => recipient.language
      }
    end
    class << self
      def fields
        [
          'FirstName',
          'LastName',
          'Email',
          'EmbeddedData',
          'ExternalData',
          'Unsubscribed',
          'Language'
        ]
      end
    end
  end
end

module Qualtrics
  class Message < Entity
    ALLOWED_CATEGORIES = %w(InviteEmails InactiveSurveyMessages ReminderEmails
                            ThankYouEmails EndOfSurveyMessages GeneralMessages
                            ValidationMessages LookAndFeelMessages)

    attr_accessor :id, :name, :category, :body, :language
    validates :category, inclusion: { in: ALLOWED_CATEGORIES }

    def self.all(library_id = nil)
      lib_id = library_id || configuration.default_library_id
      response = get('getLibraryMessages', {'LibraryID' => lib_id})
      if response.success?
        response.result.map do |category, messages|
          messages.map do |message_id, name|
            new(id: message_id, name: name, category: category_map[category])
          end
        end.flatten
      else
        []
      end
    end

    def initialize(options={})
      @name = options[:name]
      @id = options[:id]
      @category = options[:category]
      @library_id = options[:library_id]
      @body = options[:body]
      @language = options[:language] || 'EN'
    end
    #
    def save
      return false if !valid?
      response = post('createLibraryMessage', attributes)

      if response.success?
        self.id = response.result['MessageID']
        true
      else
        false
      end
    end
    #
    # def destroy
    #   response = post('deleteLibraryMessage', {
    #     'LibraryID' => library_id,
    #     'MessageID' => self.id
    #   })
    #   response.success?
    # end
    #
    def attributes
      {
        'LibraryID' => library_id,
        'Category' => category,
        'Name' => name,
        'Message' => body,
        'Language' => language
      }
    end

    def self.category_map
      {
        'INVITE' =>         'InviteEmails',
        'REMINDER' =>       'ReminderEmails',
        'THANKYOU' =>       'ThankYouEmails',
        'ENDOFSURVEY' =>    'EndOfSurveyMessages',
        'INACTIVESURVEY' => 'InactiveSurveyMessages',
        'GENERAL' =>        'GeneralMessages',
        'LOOKANDFEEL' =>    'LookAndFeelMessages'
      }
    end
  end
end

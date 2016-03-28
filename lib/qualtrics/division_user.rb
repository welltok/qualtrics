module Qualtrics
  class DivisionUser < Entity
    attr_accessor :id, :username, :user_password, :first_name, :last_name, :email, :type, :division_id

    def initialize(options = {})
      @username = options[:username]
      @user_password = options[:user_password]
      @first_name = options[:first_name]
      @last_name = options[:last_name]
      @email = options[:email]
      @type = options[:type]
      @division_id = options[:division_id]
    end
    
    def create
      response = post('createUser', {
        'NewUsername' => username,
        'NewPassword' => user_password,
        'FirstName' => first_name,
        'LastName' => last_name,
        'Email' => email,
        'Type' => type,
        'DivisionID' => division_id,
        'Organization' => configuration.organization
      })

      if response.success?
        self.id = response.result['UserID']
        true
      else
        false
      end      
    end

    def configuration
      Qualtrics.configuration
    end
  end
end
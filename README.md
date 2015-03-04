# Qualtrics

A nice wrapper for the Qualtrics REST API. Currently under fast iterations. 
Full functional, but may see many changes before 1.0 release. 
Not recommended for production use before then.

Just add the gem.

    gem 'qualtrics'
    
## Configuration

Set the user, token and default library id

    Qualtrics.configure do |config|
      config.user = ENV['QUALTRICS_USER']
      config.token = ENV['QUALTRICS_TOKEN']
      config.default_library_id = ENV['QUALTRICS_LIBRARY_ID']
    end

## Example usage

Add/remove a panel to Qualtrics

    panel = Qualtrics::Panel.new({
      name: 'My first panel'
    })

    panel.save
    panel.destroy
    
Add/remove recipients to panel
    
    recipient = Qualtrics::Recipient.new({
      panel_id: panel.id
    })
    
    recipient.save
    recipient.delete
    
Retrieve all survey and messages in Qualtrics
    
    Qualtrics::Survey.all   -> returns array of Qualtrics::Survey objects
    Qualtrics::Message.all
  
Send a survey to a panel or individual with the Mailer object

    mailer = Qualtrics::Mailer.new({
      from_email: 'from_email',
      from_name: 'from_name',
      subject: 'subject'
    })
  
    mailer.send_survey_to_individual(recipient, message, survey)
    mailer.send_survey_to_panel(panel, message, survey)
    
Retrieve submission results if you know the Qualtrics response_qid
  
    submission = Qualtrics::Submission.new({
      id: 'response_qid',
      survey_id: 'survey_id'
    })
    
    submission.raw_csv
    
## Interesting features

  Can batch update all the recipients in a panel for efficency.

## TODO

  1. Allow retrieving responses in different formats.
  2. Qualtrics does not all deleting library messages, find a way to test around this.
  
## Contributing

1. Fork it ( https://github.com/[my-github-username]/qualtrics/fork 
2. Add tests.
3. Make your feature addition or bug fix.
4. Send me a pull request.


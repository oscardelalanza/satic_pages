class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
  
  # TODO: listing 11.11 The application mailer with a new default from address.
end

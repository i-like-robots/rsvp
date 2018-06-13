class ApplicationMailer < ActionMailer::Base
  default from: "rsvp.bot@#{ENV['APP_DOMAIN']}"
end

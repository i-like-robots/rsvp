class ApplicationMailer < ActionMailer::Base
  default from: "wedding.bot@#{ENV['APP_DOMAIN']}"
end

# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview
  def rsvp_confirmation
    guest = Guest.first
    AdminMailer.rsvp_confirmation(guest)
  end
end

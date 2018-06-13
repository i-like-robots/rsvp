# Preview all emails at http://localhost:3000/rails/mailers/guest_mailer
class GuestMailerPreview < ActionMailer::Preview
  def rsvp_confirmation
    guest = Guest.first
    GuestMailer.rsvp_confirmation(guest)
  end

  def notify
    guest = Guest.first
    notification = Notification.first
    GuestMailer.notify(guest, notification)
  end
end

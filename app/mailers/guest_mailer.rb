class GuestMailer < ApplicationMailer
  default reply_to: ENV['ADMIN_EMAIL']

  def rsvp_confirmation (guest)
    @guest = guest
    mail(subject: 'Thank you for your RSVP 🍾!', to: @guest.email)
  end

  def notify (guest, notification)
    @guest = guest
    @message = notification.message

    mail(subject: notification.subject, to: @guest.email)
  end
end

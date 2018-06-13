class AdminMailer < ApplicationMailer
  default to: ENV['ADMIN_EMAIL']

  def rsvp_confirmation (guest)
    @guest = guest
    mail(subject: "New RSVP received from #{@guest.name} 🎉")
  end
end

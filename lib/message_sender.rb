module MessageSender
  def self.confirmation_code (guest)
    self.send_message(guest.phone_number, "Here's your verification code: #{guest.verification_code}")
  end

  def self.rsvp_confirmation (guest)
    self.send_message(guest.phone_number, 'Thank you for your RSVP 🍾! We\'ll be in touch when we have more information')
  end

  private

  def self.send_message (phone_number, message)
    message = self.twilio_client.messages.create(
      from: ENV['TWILIO_NUMBER'],
      to: phone_number,
      body: message
    )

    message.status == 'queued'
  end

  def self.twilio_client
    @twilio_client ||= Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
  end
end

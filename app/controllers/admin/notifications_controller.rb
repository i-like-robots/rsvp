module Admin
  class NotificationsController < Admin::ApplicationController

    def send_to_all
      notification = Notification.find_by_id(params[:id].to_i)
      guests = Guest.all

      guests.each do | guest |
        mail_notify = GuestMailer.notify(guest, notification)
        mail_notify.deliver_now
      end

      flash[:success] = "Notification sent to #{guests.length} guests"

      notification.update(sent: true)

      redirect_to(action: 'index')
    end

    def send_test
      notification = Notification.find_by_id(params[:id].to_i)
      guest = Guest.new(name: 'Bride 👰', email: ENV['ADMIN_EMAIL'], plus_one: 'Groom 🎩')

      mail_notify = GuestMailer.notify(guest, notification)
      mail_notify.deliver_now

      flash[:success] = "Test notification sent to #{guest.email}"

      redirect_to(action: 'index')
    end

  end
end

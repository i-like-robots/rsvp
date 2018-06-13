class RsvpController < ApplicationController
  before_action :get_guest

  def index
    # take the name from the URL
    if @guest.name == nil and params[:name]
      @guest.name = params[:name]
    end

    # don't let confirmed users confirm again...
    if @guest.confirmed
      redirect_to(controller: 'guest', action: 'profile')
    end
  end

  def submit
    # create or update
    @guest.assign_attributes(guest_params)

    # validate and persist guest to DB
    if @guest.save
      session[:guest_uuid] = @guest.uuid

      # redirect to the next step
      redirect_to(action: 'confirm')
    else
      err = @guest.errors.first

      flash.now[:error] = "RSVP failed, #{Guest.human_attribute_name(err.first)} #{err.last}"

      # render the form again
      render :index
    end
  end

  def confirm
  end

  def verify
    # set the status of the guest to confirmed
    if @guest.update(confirmed: true)

      # notify of success
      flash[:success] = 'RSVP saved'

      # email the lucky couple
      mail_admin = AdminMailer.rsvp_confirmation(@guest)
      mail_admin.deliver_now

      # email the guest
      mail_guest = GuestMailer.rsvp_confirmation(@guest)
      mail_guest.deliver_now

      # text the guest, too
      MessageSender.rsvp_confirmation(@guest)

      # clear the guest session
      session.delete(:guest_uuid)

      # redirect to the next step
      redirect_to(action: 'success')
    else
      flash.now[:error] = "RSVP failed, #{@guest.errors.first.last}"

      # render the form again
      render :confirm
    end
  end

  def success
  end

  private

  def get_guest
    @guest = Guest.where(uuid: session[:guest_uuid]).first_or_initialize
  end

  def guest_params
    params.require(:guest).permit(:name, :email, :phone_number, :plus_one)
  end

end

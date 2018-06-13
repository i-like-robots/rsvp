class GuestController < ApplicationController
  def login
    # don't waste codes on pre-authorised users!
    if session[:guest_uuid] != nil
      redirect_to(action: 'profile')
    end
  end

  def submit
    # try to the find the user
    num = PhoneNumber.normalize(params[:phone_number])

    guest = Guest.find_by(phone_number: num)

    if guest
      session[:guest_uuid] = guest.uuid

      # redirect to next step
      redirect_to(action: 'confirm')
    else
      flash.now[:error] = 'We couldnʼt find anybody with that number'

      # render the form again
      render :login
    end
  end

  def confirm
    guest = authorized_guest

    # assign the user a random code
    guest.update(verification_code: random_code)

    # text the guest their code
    MessageSender.confirmation_code(guest)

    # notify user that message has been sent
    flash.now[:success] = "Confirmation code sent to #{guest.phone_number}"
  end

  def verify
    guest = authorized_guest

    code = params[:code].try(:to_i) || nil

    if code != nil and guest.verification_code == code
      # remove the code
      guest.update(verification_code: nil)

      # redirect to their profile
      redirect_to(action: 'profile')
    else
      flash.now[:error] = "Sorry, that code didnʼt match"

      # render the form again
      render :confirm
    end
  end

  def profile
    @guest = authorized_guest
  end

  def update
    @guest = authorized_guest

    # validate and persist guest to DB
    if @guest.update(guest_params)
      flash.now[:success] = 'Your details have been updated'
    else
      err = @guest.errors.first
      flash.now[:error] = "Update failed, #{Guest.human_attribute_name(err.first)} #{err.last}"
    end

    render :profile
  end

  def logout
    # clear the guest session
    session.delete(:guest_uuid)

    flash[:warning] = "Youʼve been logged out"

    redirect_to(action: 'login')
  end

  private

  def authorized_guest
    Guest.find_by(uuid: session[:guest_uuid])
  end

  def random_code
    rand(100000...999999).to_s
  end

  def guest_params
    params.require(:guest).permit(:name, :email, :phone_number, :plus_one)
  end
end

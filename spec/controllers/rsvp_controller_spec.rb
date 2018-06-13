require 'rails_helper'

RSpec.describe RsvpController, :type => :controller do

  describe '#index' do
    subject { get :index }

    context 'with a confirmed guest' do
      let(:guest) { build(:guest, :is_confirmed) }

      before(:each) do
        expect(Guest).to receive(:new).and_return(guest)
      end

      it 'redirects to the guest profile page' do
        expect(subject).to redirect_to(controller: 'guest', action: 'profile')
      end
    end
  end

  describe '#submit' do
    let(:guest) { build(:guest) }
    let(:post_data) { { guest: form_data } }

    subject { post :submit, post_data }

    before(:each) do
      expect(Guest).to receive(:new).and_return(guest)
    end

    context 'with invalid data' do
      let(:form_data) { attributes_for(:guest, :with_name, :with_email, :with_invalid_phone_number) }

      before(:each) do
        subject
      end

      it 'does not save the guest' do
        expect(assigns(:guest).persisted?).to eq(false)
      end

      it 'renders the new guest form' do
        expect(subject).to render_template(:index)
      end

      it 'flashes the error message' do
        expect(flash[:error]).to eq('RSVP failed, Phone number is invalid')
      end
    end

    context 'with valid data' do
      let(:form_data) { attributes_for(:guest, :with_name, :with_email, :with_phone_number) }

      before(:each) do
        subject
      end

      it 'saves the guest' do
        expect(assigns(:guest).persisted?).to eq(true)
      end

      it 'assigns the guest UUID to the session' do
        expect(session[:guest_uuid]).to eq(assigns(:guest).uuid)
      end

      it 'redirects to the confirmation page' do
        expect(subject).to redirect_to(action: 'confirm')
      end
    end
  end

  describe '#confirm' do
    it 'returns a 200' do
      get :confirm
      expect(response).to have_http_status(:success)
    end
  end

  describe '#verify' do
    let(:guest_mailer) { double(:guest_mailer) }
    let(:admin_mailer) { double(:admin_mailer) }
    let(:guest) { build(:guest, :with_name, :with_email, :with_phone_number, :with_uuid) }

    subject { get :verify }

    before(:each) do
      allow(Guest).to receive(:new).and_return(guest)

      allow(GuestMailer).to receive(:rsvp_confirmation).and_return(guest_mailer)
      allow(guest_mailer).to receive(:deliver_now)

      allow(AdminMailer).to receive(:rsvp_confirmation).and_return(admin_mailer)
      allow(admin_mailer).to receive(:deliver_now)

      allow(MessageSender).to receive(:rsvp_confirmation)

      subject
    end

    it 'sets the guest to confirmed' do
      expect(assigns(:guest).confirmed).to eq(true)
    end

    it 'triggers email notifications' do
      expect(GuestMailer).to have_received(:rsvp_confirmation).with(assigns(:guest))
      expect(AdminMailer).to have_received(:rsvp_confirmation).with(assigns(:guest))
    end

    it 'triggers an SMS to the guest' do
      expect(MessageSender).to have_received(:rsvp_confirmation).with(assigns(:guest))
    end

    it 'clears the session' do
      expect(session[:guest_uuid]).to equal(nil)
    end

    it 'redirects to the success page' do
      expect(subject).to redirect_to(action: 'success')
    end
  end

  describe '#success' do
    it 'returns a 200' do
      get :success
      expect(response).to have_http_status(:success)
    end
  end

end

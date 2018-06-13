require 'rails_helper'

RSpec.describe GuestController, type: :controller do

  describe '#login' do
    subject { get :login }

    context 'with a guest session' do
      it 'redirects to the profile page' do
        session[:guest_uuid] = 1234
        expect(subject).to redirect_to(action: 'profile')
      end
    end
  end

  describe '#submit' do
    let(:guest) { build(:guest) }
    let(:post_data) { { phone_number: '+44123491289' } }

    subject { post :submit, post_data }

    context 'with unknown user' do
      before(:each) do
        expect(Guest).to receive(:find_by).and_return(nil)
        subject
      end

      it 'renders the login form' do
        expect(subject).to render_template(:login)
      end
    end

    context 'with a known user' do
      before(:each) do
        expect(Guest).to receive(:find_by).and_return(guest)
        subject
      end

      it 'redirects to the confirmation page' do
        expect(subject).to redirect_to(action: 'confirm')
      end
    end
  end

  describe '#confirm' do
    let(:guest) { build(:guest) }

    before(:each) do
      allow(Guest).to receive(:find_by).and_return(guest)
      allow(MessageSender).to receive(:confirmation_code)

      get :confirm
    end

    it 'assigns the guest a random code' do
      expect(guest.verification_code).to be_between(000000, 999999)
    end

    it 'triggers an SMS to the guest' do
      expect(MessageSender).to have_received(:confirmation_code).with(guest)
    end
  end

  describe '#verify' do
    let(:guest) { build(:guest, :with_verification_code) }

    subject { post :verify, post_data }

    before(:each) do
      expect(Guest).to receive(:find_by).and_return(guest)
    end

    context 'with incorrect code' do
      let(:post_data) { { code: 123789 } }

      it 'renders the confirm form' do
        expect(subject).to render_template(:confirm)
      end
    end

    context 'with correct code' do
      let(:post_data) { { code: 123456 } }

      it 'redirects to the profile page' do
        expect(subject).to redirect_to(action: 'profile')
      end
    end
  end

  describe '#profile' do
    let(:guest) { build(:guest, :with_name, :with_email, :with_phone_number) }

    before(:each) do
      allow(Guest).to receive(:find_by).and_return(guest)

      get :profile
    end

    it 'assigns the guest' do
      expect(assigns(:guest)).to eq(guest)
    end
  end

  describe '#update' do
    let(:guest) { build(:guest) }
    let(:post_data) { { guest: form_data } }

    subject { patch :update, post_data }

    before(:each) do
      expect(Guest).to receive(:find_by).and_return(guest)
    end

    context 'with invalid data' do
      let(:form_data) { attributes_for(:guest, :with_name, :with_email, :with_invalid_phone_number) }

      before(:each) do
        subject
      end

      it 'does not save the guest' do
        expect(assigns(:guest).persisted?).to eq(false)
      end

      it 'flashes the error message' do
        expect(flash[:error]).to eq('Update failed, Phone number is invalid')
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
    end
  end

  describe '#logout' do
    subject { get :logout }

    before(:each) do
      session[:guest_uuid] = 1234
    end

    it 'clears the guest session' do
      subject
      expect(session[:guest_uuid]).to eq(nil)
    end

    it 'redirects to the profile page' do
      expect(subject).to redirect_to(action: 'login')
    end
  end

end

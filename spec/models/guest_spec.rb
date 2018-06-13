require 'rails_helper'

RSpec.describe Guest, :type => :model do

  describe 'validation' do
    context 'without a name' do
      subject(:instance) { build(:guest, :with_email, :with_phone_number) }

      it 'fails validation' do
        expect(instance.valid?).to eq(false)
      end
    end

    context 'without an email' do
      subject(:instance) { build(:guest, :with_name, :with_phone_number) }

      it 'fails validation' do
        expect(instance.valid?).to eq(false)
      end
    end

    context 'with an invalid email' do
      subject(:instance) { build(:guest, :with_name, :with_invalid_email, :with_phone_number) }

      it 'fails validation' do
        expect(instance.valid?).to eq(false)
      end
    end

    context 'without a phone number' do
      subject(:instance) { build(:guest, :with_name, :with_email) }

      it 'fails validation' do
        expect(instance.valid?).to eq(false)
      end
    end

   context 'with an invalid phone number' do
      subject(:instance) { build(:guest, :with_name, :with_email, :with_invalid_phone_number) }

      it 'fails validation' do
        expect(instance.valid?).to eq(false)
      end
    end

    context 'with a funky phone number format' do
      subject(:instance) { build(:guest, :with_name, :with_email) }

      it 'enforces leading +' do
        instance.phone_number = '44791 3311 331'
        expect(instance.phone_number).to eq('+447913311331')
      end

      it 'assumes 0 leading numbers are UK' do
        instance.phone_number = '0791 3311 331'
        expect(instance.phone_number).to eq('+447913311331')
      end

      it 'removes non-integer characters' do
        instance.phone_number = '+44/791-3311331'
        expect(instance.phone_number).to eq('+447913311331')
      end
    end

    context 'with valid data' do
      subject(:instance) { build(:guest, :with_name, :with_email, :with_phone_number) }

      it 'passes validation' do
        expect(instance.valid?).to eq(true)
      end
    end
  end

  describe 'triggers' do
    subject(:instance) { build(:guest, :with_name, :with_email, :with_phone_number) }

    describe 'before_create' do
      it 'triggers add_uuid' do
        expect(instance).to receive(:add_uuid)
        instance.save
      end
    end

    describe '#add_uuid' do
      it 'appends a UUID' do
        instance.add_uuid
        expect(instance.uuid).to match(/\A\w{8}-\w{4}-\w{4}-\w{4}-\w{12}\z/)
      end
    end
  end

end

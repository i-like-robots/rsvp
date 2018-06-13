FactoryGirl.define do

  factory :guest do
    name ''
    email ''
    phone_number ''
    plus_one ''
    uuid ''
    confirmed false
    verification_code nil

    trait :with_name do
      name 'Joe Bloggs'
    end

    trait :with_email do
      email 'joe.bloggs@example.com'
    end

    trait :with_invalid_email do
      email 'joe.bloggs(at)example.com'
    end

    trait :with_phone_number do
      phone_number '+447913311331'
    end

    trait :with_invalid_phone_number do
      phone_number 'call me! 001'
    end

    trait :with_plus_one do
      plus_one 'John Doe'
    end

    trait :with_uuid do
      uuid '00000000-0000-0000-0000-000000000000'
    end

    trait :with_verification_code do
      verification_code 123456
    end

    trait :is_confirmed do
      confirmed true
    end
  end

end

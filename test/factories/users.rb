# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    email { Faker::Internet.unique.email }

    trait :admin do
      admin { true }
    end

    trait :with_password do
      transient do
        fake_password { Faker::Internet.password }
      end

      password { fake_password }
      confirm_password { fake_password }
    end
  end
end

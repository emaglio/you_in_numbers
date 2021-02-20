# frozen_string_literal: true

FactoryBot.define do
  factory :subject do
    email { Faker::Internet.unique.email }
    sequence(:firstname) { |n| "#{Faker::Name.first_name}-#{n}" }
    sequence(:lastname) { |n| "#{Faker::Name.first_name}-#{n}" }
    dob { Faker::Date.birthday }
    gender { Faker::Gender.binary_type }
    height { Faker::Number.between(from: 100, to: 200) }
    weight { Faker::Number.between(from: 50, to: 100) }

    user
  end
end

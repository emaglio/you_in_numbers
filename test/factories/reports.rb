# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { Faker::Name.name }

    user
    subject { create(:subject, user: user) }

    trait :with_template do
      template { 'default' }
    end

    trait :with_files do
      transient do
        upload_file do
          ActionDispatch::Http::UploadedFile.new(
            tempfile: File.new(Rails.root.join('test/files/cpet.xlsx'))
          )
        end
      end

      cpet_file_path { upload_file }
      user { trb_create(:user) }
      subject { trb_create(:subject, user: user) }
    end
  end
end

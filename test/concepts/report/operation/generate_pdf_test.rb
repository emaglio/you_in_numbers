# frozen_string_literal: true

require 'test_helper'

class ReportOperationGeneratePdfTest < MiniTest::Spec
  let(:admin) { admin_for }
  let(:user) { User::Operation::Create.(params: { email: 'test@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:user2) { User::Operation::Create.(params: { email: 'test2@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:subject_params) { { firstname: 'Ema', lastname: 'Maglio', dob: '01/01/1980' } }
  let(:subject) do
    Subject.find_by(subject_params) ||
      Subject::Operation::Create.(
        subject_params.merge(
          user_id: user.id,
          gender: 'Male',
          height: '180',
          weight: '80',
          phone: '912873',
          email: 'ema@email.com'
        ),
        'current_user' => user
      )['model']
  end
  let(:upload_file) do
    ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join('test/files/cpet.xlsx'))
    )
  end
  let(:report) do
    factory(
      Report::Operation::Create,
      params: {
        user_id: user.id,
        subject_id: subject.id,
        title: 'My report',
        cpet_file_path: upload_file,
        template: 'default'
      },
      current_user: user
    )[:model]
  end

  it 'generate pdf' do
    skip 'need to move 4 images into the temp_file folder to test this'
    _(user.email).must_equal 'test@email.com'
    _(subject.firstname).must_equal 'Ema'

    Company::Operation::Create.(
      params: {
        user_id: user.id, name: 'My Company', address_1: 'address 1', address_2: 'address 2', city: 'Freshwater',
        postcode: '2096', country: 'Australia', email: 'company@email.com', phone: '12345',
        website: 'wwww.company.com.au', logo: File.open('test/images/logo.jpeg')
      }, current_user: user
    )[:model]

    result = Report::Operation::GeneratePdf.(params: { id: report.id }, current_user: user)
    result.success?.must_equal true
  end
end

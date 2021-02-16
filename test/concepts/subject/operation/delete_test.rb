# frozen_string_literal: true

require 'test_helper'

class SubjectOperationDeleteTest < MiniTest::Spec
  let(:user) { User::Operation::Create.(params: { email: 'test@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:user2) { User::Operation::Create.(params: { email: 'test2@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:subject) do
    factory(
      Subject::Operation::Create,
      params: {
        user_id: user.id,
        firstname: 'Ema',
        lastname: 'Maglio',
        gender: 'Male',
        dob: '01/01/1980',
        height: '180',
        weight: '80',
        phone: '912873',
        email: 'ema@email.com'
      }, current_user: user
    )[:model]
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

  it 'only owner can delete subject' do
    assert_raises ApplicationController::NotAuthorizedError do
      Subject::Operation::Delete.(params: { id: subject.id }, current_user: user2)
    end

    result = Subject::Operation::Delete.(params: { id: subject.id }, current_user: user)
    _(result.success?).must_equal true
    _(Subject.where(id: subject.id).size).must_equal 0
    _(Report.where(subject_id: subject.id).size).must_equal 0
  end
end

# frozen_string_literal: true

require 'test_helper'

class ReportOperationDeleteTest < MiniTest::Spec
  let(:admin) { admin_for }
  let(:user) { User::Operation::Create.(params: { email: 'test@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:user2) { User::Operation::Create.(params: { email: 'test2@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:subject_params) { { firstname: 'Ema', lastname: 'Maglio', dob: '01/01/1980' } }
  let(:subject) do
    Subject.find_by(subject_params) ||
      Subject::Operation::Create.(
        params: subject_params.merge(
          user_id: user.id,
          gender: 'Male',
          height: '180',
          weight: '80',
          phone: '912873',
          email: 'ema@email.com'
        ),
        current_user: user
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

  it 'only report owner can delete report' do
    # this needs to be created because the id 1 is used to edit the template and DatabaseCleaner deletes it
    _(admin.email).must_equal 'admin@email.com'
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'
    _(subject.firstname).must_equal 'Ema'

    assert_raises ApplicationController::NotAuthorizedError do
      Report::Operation::Delete.(params: { id: report.id }, current_user: user2)
    end

    result = Report::Operation::Delete.(params: { id: report.id }, current_user: user)

    _(result.success?).must_equal true

    _(Report.where(id: report.id).count).must_equal 0
  end
end

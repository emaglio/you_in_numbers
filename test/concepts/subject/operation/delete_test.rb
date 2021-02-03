# frozen_string_literal: true

require 'test_helper.rb'

class SubjectOperationDeleteTest < MiniTest::Spec
  it 'only owner can delete subject' do
    user = User::Operation::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    _(user.success?).must_equal true
    user2 = User::Operation::Create.(email: 'tes2t@email.com', password: 'password', confirm_password: 'password')

    subject = Subject::Operation::Create.({
      user_id: user['model'].id,
      firstname: 'Ema',
      lastname: 'Maglio',
      gender: 'Male',
      dob: '01/01/1980',
      height: '180',
      weight: '80',
      phone: '912873',
      email: 'ema@email.com'
    }, 'current_user' => user)
    _(subject.success?).must_equal true

    upload_file = ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join('test/files/cpet.xlsx'))
    )

    report = Report::Operation::Create.({
      user_id: user['model'].id,
      subject_id: subject['model'].id,
      title: 'My report',
      cpet_file_path: upload_file,
      template: 'default'
    }, 'current_user' => user['model'])
    _(report.success?).must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Subject::Operation::Delete.(
        { id: subject['model'].id },
          'current_user' => user2['model']
      )
    end

    result = Subject::Operation::Delete.({ id: subject['model'].id }, 'current_user' => user['model'])
    _(result.success?).must_equal true
    _(Subject.where(id: subject['model'].id).size).must_equal 0
    _(Report.where(subject_id: subject['model'].id).size).must_equal 0
  end
end

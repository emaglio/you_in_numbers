# frozen_string_literal: true

require 'test_helper.rb'

class UserOperationDeleteTest < MiniTest::Spec
  let(:admin) { admin_for }
  let(:user2) { User::Operation::Create.(email: 'test2@email.com', password: 'password', confirm_password: 'password')['model'] }
  let(:subject) do
    Subject::Operation::Create.(
      {
        user_id: user.id,
        firstname: 'Ema',
        lastname: 'Maglio',
        gender: 'Male',
        dob: '01/01/1980',
        height: '180',
        weight: '80',
        phone: '912873',
        email: 'ema@email.com'
      },
      'current_user' => user
    )['model']
  end

  let(:default_params) { { password: 'password', confirm_password: 'password' } }
  let(:expected_attrs) { { email: 'test@email.com' } }
  let(:user) { User::Operation::Create.(default_params.merge(expected_attrs))['model'] }

  it 'only current_user can delete user' do
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'

    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::Delete.(
        { id: user.id },
          'current_user' => user2
      )
    end

    res = User::Operation::Delete.({ id: user.id }, 'current_user' => user)
    _(res.success?).must_equal true
  end

  it 'delete Company, Reports and Subjects if delete User' do
    _(user.email).must_equal 'test@email.com'

    # create company
    company = Company::Operation::Create.({ user_id: user.id, name: 'My Company' }, 'current_user' => user)
    _(company.success?).must_equal true

    upload_file = ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join('test/files/cpet.xlsx'))
    )

    # create 2 Reports
    report1 = Report::Operation::Create.({
      user_id: user.id,
      subject_id: subject.id,
      title: 'My report',
      cpet_file_path: upload_file,
      template: 'default'
    }, 'current_user' => user)
    _(report1.success?).must_equal true

    report2 = Report::Operation::Create.({
      user_id: user.id,
      subject_id: subject.id,
      title: 'My report',
      cpet_file_path: upload_file,
      template: 'default'
    }, 'current_user' => user)
    _(report2.success?).must_equal true

    _(Company.where(user_id: user.id).size).must_equal 1
    _(Report.where(user_id: user.id).size).must_equal 2

    User::Operation::Delete.({ id: user.id }, 'current_user' => user)

    _(Company.where(user_id: user.id).size).must_equal 0
    _(Report.where(user_id: user.id).size).must_equal 0
    _(Subject.where(user_id: user.id).size).must_equal 0
  end
end

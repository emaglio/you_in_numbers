# frozen_string_literal: true

require 'test_helper'

class ReportOperationEditAtTest < MiniTest::Spec
  let(:admin) { admin_for }
  let(:user) { User::Operation::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')['model'] }
  let(:user2) { User::Operation::Create.(email: 'test2@email.com', password: 'password', confirm_password: 'password')['model'] }
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

  it 'only owner can edit AT' do
    # this needs to be created because the id 1 is used to edit the template and DatabaseCleaner deletes it
    _(admin.email).must_equal 'admin@email.com'
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'
    _(subject.firstname).must_equal 'Ema'

    upload_file = ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join('test/files/cpet.xlsx'))
    )

    report = Report::Operation::Create.({
                                          user_id: user.id,
                                          subject_id: subject.id,
                                          title: 'My report',
                                          cpet_file_path: upload_file,
                                          template: 'default'
                                        }, 'current_user' => user)
    _(report.success?).must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Report::Operation::EditAt.({
                                   id: report['model'].id
                                 }, 'current_user' => user2)
    end

    # check errors
    result = Report::Operation::EditAt.({ id: report['model'].id }, 'current_user' => user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:at_position=>["must be filled"]}'

    at_calculated = report['model']['cpet_results']['at_index']
    _(report['model']['cpet_results']['at_index']).must_equal report['model']['cpet_results']['edited_at_index']

    # successfully editing AT
    result = Report::Operation::EditAt.({ id: report['model'].id, 'at_position' => 80 }, 'current_user' => user)
    _(result.success?).must_equal true
    _(result['model']['cpet_results']['at_index']).wont_equal result['model']['cpet_results']['edited_at_index']
    _(result['model']['cpet_results']['at_index']).must_equal at_calculated
    _(result['model']['cpet_results']['edited_at_index']).must_equal 80
  end
end

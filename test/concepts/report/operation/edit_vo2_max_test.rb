# frozen_string_literal: true

require 'test_helper'

class ReportOperationVo2MaxTest < MiniTest::Spec
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

  it 'only owner can edit VO2max' do
    # this needs to be created because the id 1 is used to edit the template and DatabaseCleaner deletes it
    _(admin.email).must_equal 'admin@email.com'
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'
    _(subject.firstname).must_equal 'Ema'

    assert_raises ApplicationController::NotAuthorizedError do
      Report::Operation::EditVO2Max.(params: { id: report.id }, current_user: user2)
    end

    # check errors
    result = Report::Operation::EditVO2Max.(params: { id: report.id }, current_user: user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect)
      .must_equal '{:vo2max_starts=>["must be filled"], :vo2max_ends=>["must be filled"],'\
                  ' :vo2max_value=>["must be filled"]}'

    _(report.cpet_results['vo2_max']).must_equal report.cpet_results['edited_vo2_max']

    # successfully editing VO2max
    result = Report::Operation::EditVO2Max.(
      params: { id: report.id, 'vo2max_starts' => 40, 'vo2max_ends' => 60, 'vo2max_value' => 1100 },
      current_user: user
    )
    _(result.success?).must_equal true
    report.reload
    _(report.cpet_results['edited_vo2_max']['index']).must_equal 60
    _(report.cpet_results['edited_vo2_max']['starts']).must_equal 40
    _(report.cpet_results['edited_vo2_max']['ends']).must_equal 60
    _(report.cpet_results['edited_vo2_max']['value']).must_equal 1100
  end
end

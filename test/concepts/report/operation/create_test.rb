# frozen_string_literal: true

require 'test_helper'

class ReportOperationCreateTest < MiniTest::Spec
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

  it 'create report successfully' do
    _(user.email).must_equal 'test@email.com'
    _(subject.firstname).must_equal 'Ema'

    upload_file = ActionDispatch::Http::UploadedFile.new(
      :tempfile => File.new(Rails.root.join('test/files/cpet.xlsx'))
    )

    report = Report::Operation::Create.(
      params: {
        user_id: user.id,
        subject_id: subject.id,
        title: 'My report',
        cpet_file_path: upload_file,
        template: 'default'
      },
      current_user: user
    )
    _(report.success?).must_equal true

    _(report['model'].title).must_equal 'My report'
    _(report['model'].user_id).must_equal user.id
    _(report['model'].content['template']).must_equal 'default'
    _(report['model'].content['subject']['height']).must_equal 180
    _(report['model'].content['subject']['weight']).must_equal 80

    # check VO2max params and results are not empty (will see if I need to test the actual values of the results)
    report['model']['cpet_params'].each do |_key, value|
      _(!value.empty?).must_equal true
    end

    report['model']['cpet_results'].each do |key, hash|
      if (key == 'at_index') || (key == 'edited_at_index')
        _(!value.nil?).must_equal true
      else
        hash.each do |_key, value|
          _(!value.nil?).must_equal true
        end
      end
    end

    # check RMR params and results are not empty (will see if I need to test the actual values of the results)
    # TODO
    # report["model"]["rmr_params"].each do |key, value|
    # end

    # report["model"]["rmr_results"].each do |key, hash|
    # end
  end

  it 'wrong input' do
    _(user.email).must_equal 'test@email.com'
    _(subject.firstname).must_equal 'Ema'

    result = Report::Operation::Create.(params: {}, current_user: user)

    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect)
      .must_equal "{:title=>[\"Can't be blank\"], :user_id=>[\"Can't be blank\"], :subject_id=>[\"Can't be blank\"],"\
                  " :template=>[\"Can't be blank\"], :cpet_file_path=>[\"At least one file must be uploaded\"], "\
                  ':rmr_file_path=>["At least one file must be uploaded"]}'

    # FIXME
    # wrong_file = ActionDispatch::Http::UploadedFile.new({
    #   :tempfile => File.new(Rails.root.join("test/files/wrong_file.xlsx"))
    # })

    # result = Report::Operation::Create.({
    #       user_id: user.id,
    #       subject_id: subject.id,
    #       title: "My report",
    #       cpet_file_path: wrong_file,
    #       rmr_file_path: wrong_file,
    #       template: "default"
    #   }, "current_user" => user)

    # result.failure?.must_equal true
    # result["result.contract.default"].errors.messages.inspect
    # .must_equal "{:cpet_file_path=>[\"The file selected doens't exist\"], "\
    #             ":rmr_file_path=>[\"The file selected doens't exist\"]}"
  end
end

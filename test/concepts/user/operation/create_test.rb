# frozen_string_literal: true

require 'test_helper.rb'

class UserOperationCreateTest < MiniTest::Spec
  let(:default_params) do
    {
      password: 'password',
      confirm_password: 'password',
      email: 'test@email.com'
    }
  end
  let(:expected_attrs) { { email: 'test@email.com' } }
  let(:user) { User::Operation::Create.(default_params)['model'] }
  let(:report_settings) do
    {
      params_list: %w[t Rf VE VO2 VCO2 RQ VE/VO2 VE/VCO2 HR VO2/Kg FAT% CHO% Phase],
      ergo_params_list: %w[Power Watt Revolution RPM],
      training_zones_settings: [35, 50, 51, 75, 76, 90, 91, 100],
      units_of_measurement: { height: 'cm', weight: 'kg' }
    }
  end
  let(:report_template) { { 'default' => MyDefault::ReportObj.clone, 'custom' => MyDefault::ReportObj.clone } }

  it do
    assert_pass(User::Operation::Create, params(firstname: 'first'), firstname: 'first') do |result|
      assert_exposes result['model'],
                     'content' => ->(actual, *) {
                       actual[:actual]['report_settings'] == ''
                       actual[:actual]['report_template'] == report_template
                     }
    end
  end

  it do
    assert_fail User::Operation::Create,
                params(email: '', password: '', confirm_password: ''),
                expected_errors: %i[email password confirm_password]
  end

  describe 'passwords not matching' do
    let(:default_params) { { password: 'password', confirm_password: 'notpassword' } }

    it do
      assert_fail User::Operation::Create, params(email: 'test@email.com'), expected_errors: %i[confirm_password] do |result|
        assert_equal({ confirm_password: ['Passwords are not matching'] }, result['contract.default'].errors.messages)
      end
    end
  end

  describe 'unique user' do
    let(:default_params) { { email: 'test@email.com', password: 'password', confirm_password: 'password' } }

    before { user }

    it do
      assert_fail User::Operation::Create, params(email: 'test@email.com'), expected_errors: %i[email] do |result|
        assert_equal({ email: ['This email has been already used'] }, result['contract.default'].errors.messages)
      end
    end
  end
end

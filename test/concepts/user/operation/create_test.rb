# frozen_string_literal: true

require 'test_helper.rb'

class UserCreateTest < MiniTest::Spec
  let(:default_params) do
    {
      password: 'password',
      confirm_password: 'password',
      email: 'test@email.com'
    }
  end
  let(:expected_attrs) { { email: 'test@email.com' } }
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
    assert_pass(User::Create, params(firstname: 'first'), firstname: 'first') do |result|
      assert_exposes result['model'],
                     'content' => ->(actual, *) {
                       actual[:actual]['report_settings'] == ''
                       actual[:actual]['report_template'] == report_template
                     }
    end
  end

  it do
    assert_fail User::Create,
                params(email: '', password: '', confirm_password: ''),
                expected_errors: %i[email password confirm_password]
  end
end

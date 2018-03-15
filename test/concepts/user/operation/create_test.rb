require 'test_helper.rb'

class UserCreateTest < MiniTest::Spec
  let(:params_pass) { { password: "password", confirm_password: "password" } }
  let(:attrs_pass) { {} }
  let(:email) { { email: 'test@email.com' } }
  let(:params) { params_pass.merge(email) }

  let(:create) { User::Create.(params) }

  describe 'empty input hash' do
    let(:params_pass) { {} }

    it do
      assert_fail User::Create, {}, {} do |result|
        assert_equal(
          {
            email: ["Can't be blank", "Wrong format"],
            password: ["Can't be blank"],
            confirm_password: ["Can't be blank"]
          },
          result["contract.default"].errors.messages
        )
      end
    end
  end

  describe 'valid inputs' do
    let(:report_settings) do
      {
        params_list: %w[t Rf VE VO2 VCO2 RQ VE/VO2 VE/VCO2 HR VO2/Kg FAT% CHO% Phase],
        ergo_params_list: %w[Power Watt Revolution RPM],
        training_zones_settings: [35, 50, 51, 75, 76, 90, 91, 100],
        units_of_measurement: { height: "cm", weight: "kg" }
      }
    end
    let(:report_template) { { "default" => MyDefault::ReportObj.clone, "custom" => MyDefault::ReportObj.clone } }

    it { assert_pass User::Create, email, email }

    it 'populates default params' do
      assert_exposes create['model'],
        email: 'test@email.com',
        'content' => ->(actual, *) {
          actual[:actual]['report_settings'] == report_settings
          actual[:actual]['report_template'] == report_template
        }
    end
  end
end

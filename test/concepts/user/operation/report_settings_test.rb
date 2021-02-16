# frozen_string_literal: true

require 'test_helper'

class UserOperationTest < MiniTest::Spec
  let(:admin) { admin_for }
  let(:user2) { User::Operation::Create.(params: { email: 'test2@email.com', password: 'password', confirm_password: 'password' })[:model] }
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
  let(:user) { User::Operation::Create.(params: default_params.merge(expected_attrs))[:model] }

  it 'report settings correct input' do
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'

    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::ReportSettings.(
        params: { id: user.id },
        current_user: user2
      )
    end

    result = User::Operation::ReportSettings.(
      params: {
        id: user.id,
        'params_list' => 'Parms0,Parms1,Parms2,Parms3',
        'load_1' => 'Load1',
        'load_1_um' => 'Load1_um',
        'load_2' => 'Load2',
        'load_2_um' => 'Load2_um',
        'fat_burning_2' => '45',
        'endurance_1' => '55',
        'endurance_2' => '65',
        'at_1' => '75',
        'at_2' => '85',
        'vo2max_1' => '95',
        um_height: 'um_h',
        um_weight: 'um_w'
      }, current_user: user
    )
    _(result.success?).must_equal true
    _(result[:model].content['report_settings']['params_list'][0]).must_equal 'Parms0'
    _(result[:model].content['report_settings']['params_list'][1]).must_equal 'Parms1'
    _(result[:model].content['report_settings']['params_list'][2]).must_equal 'Parms2'
    _(result[:model].content['report_settings']['params_list'][3]).must_equal 'Parms3'
    _(result[:model].content['report_settings']['ergo_params_list'][0]).must_equal 'Load1'
    _(result[:model].content['report_settings']['ergo_params_list'][1]).must_equal 'Load1_um'
    _(result[:model].content['report_settings']['ergo_params_list'][2]).must_equal 'Load2'
    _(result[:model].content['report_settings']['ergo_params_list'][3]).must_equal 'Load2_um'
    _(result[:model].content['report_settings']['training_zones_settings'][0]).must_equal 35
    _(result[:model].content['report_settings']['training_zones_settings'][1]).must_equal 45
    _(result[:model].content['report_settings']['training_zones_settings'][2]).must_equal 55
    _(result[:model].content['report_settings']['training_zones_settings'][3]).must_equal 65
    _(result[:model].content['report_settings']['training_zones_settings'][4]).must_equal 75
    _(result[:model].content['report_settings']['training_zones_settings'][5]).must_equal 85
    _(result[:model].content['report_settings']['training_zones_settings'][6]).must_equal 95
    _(result[:model].content['report_settings']['units_of_measurement']['height']).must_equal 'um_h'
    _(result[:model].content['report_settings']['units_of_measurement']['weight']).must_equal 'um_w'
  end

  it 'report settings wrong input' do
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'

    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::ReportSettings.(
        params: { id: user.id },
        current_user: user2
      )
    end

    result = User::Operation::ReportSettings.(
      params: { id: user.id },
      current_user: user
    )
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal "{:fat_burning_2=>[\"Can't be blank\", "\
        "\"This must be greater than 35\"], :endurance_1=>[\"Can't be blank\", \"This range was wrong or over the "\
        "previous one\"], :endurance_2=>[\"Can't be blank\", \"This range was wrong or over the previous one\"], "\
        ":at_1=>[\"Can't be blank\", \"This range was wrong or over the previous one\"], :at_2=>[\"Can't be blank\","\
        " \"This range was wrong or over the previous one\"], :vo2max_1=>[\"Can't be blank\", \"This range was wrong "\
        "or over the previous one\"], :load_1=>[\"Can't be blank\"], :load_1_um=>[\"Can't be blank\"], :load_2=>[\"Can'"\
        "t be blank\"], :load_2_um=>[\"Can't be blank\"], :um_height=>[\"Can't be blank\"], "\
        ":um_weight=>[\"Can't be blank\"]}"
  end
end

# frozen_string_literal: true

require 'test_helper'
require_dependency 'user/contract/edit_template.rb'

class UserOperationEditObjTest < MiniTest::Spec
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

  it 'default settings' do
    _(user.email).must_equal 'test@email.com'

    user.content['report_settings'].each do |_key, value|
      _((!value.empty?)).must_equal true
    end

    user.content['report_template'].each do |_key, value|
      _((!value.empty?)).must_equal true
    end
  end

  it 'only current user can edit custom template successfully' do
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'

    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::EditObj.(
        { id: user.id },
        'current_user' => user2
      )
    end

    # move up third element
    result = User::Operation::EditObj.({ id: user.id, 'move_up' => '2' }, 'current_user' => user)
    # _(result["result.contract.default"].errors.messages.inspect).must_equal ""
    _(result.success?).must_equal true
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']

    _(default.size).must_equal 4
    _(custom.size).must_equal 4
    _(custom[0][:type]).must_equal 'report/cell/chart'
    _(custom[0][:index]).must_equal 0
    _(custom[1][:type]).must_equal 'report/cell/summary_table'
    _(custom[1][:index]).must_equal 1
    _(custom[2][:type]).must_equal 'report/cell/chart'
    _(custom[2][:index]).must_equal 2
    _(custom[3][:type]).must_equal 'report/cell/training_zones'
    _(custom[3][:index]).must_equal 3

    # move down second element
    result = User::Operation::EditObj.({ id: user.id, 'move_down' => '1' }, 'current_user' => user)
    _(result.success?).must_equal true
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']

    _(default.size).must_equal 4
    _(custom.size).must_equal 4
    _(custom[0][:type]).must_equal 'report/cell/chart'
    _(custom[0][:index]).must_equal 0
    _(custom[1][:type]).must_equal 'report/cell/chart'
    _(custom[1][:index]).must_equal 1
    _(custom[2][:type]).must_equal 'report/cell/summary_table'
    _(custom[2][:index]).must_equal 2
    _(custom[3][:type]).must_equal 'report/cell/training_zones'
    _(custom[3][:index]).must_equal 3

    # edit first chart
    result = User::Operation::UpdateChart.(
      {
        id: user.id,
        'title' => 'newTitle',
        'edit_chart' => '0',
        'y1_select' => 'something',
        'y2_select' => 'something2',
        'y1_scale' => '1'
      },
      'current_user' => user
    )
    _(result.success?).must_equal true
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']

    _(default.size).must_equal 4
    _(custom.size).must_equal 4
    _(custom[0][:type]).must_equal 'report/cell/chart'
    _(custom[0][:index]).must_equal 0
    _(custom[0][:title]).must_equal 'newTitle'
    _(custom[0][:y1][:name]).must_equal 'something'
    _(custom[0][:y2][:name]).must_equal 'something2'
    _(custom[1][:type]).must_equal 'report/cell/chart'
    _(custom[1][:index]).must_equal 1
    _(custom[1][:y1][:name]).must_equal 'HR'
    _(custom[1][:y2][:name]).must_equal 'Power'
    _(custom[2][:type]).must_equal 'report/cell/summary_table'
    _(custom[2][:index]).must_equal 2
    _(custom[3][:type]).must_equal 'report/cell/training_zones'
    _(custom[3][:index]).must_equal 3

    # delete the first chart
    result = User::Operation::EditObj.({ id: user.id, 'delete' => '0' }, 'current_user' => user)
    _(result.success?).must_equal true
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']

    _(default.size).must_equal 4
    _(custom.size).must_equal 3
    _(custom[0][:type]).must_equal 'report/cell/chart'
    _(custom[0][:index]).must_equal 0
    _(custom[1][:type]).must_equal 'report/cell/summary_table'
    _(custom[1][:index]).must_equal 1
    _(custom[2][:type]).must_equal 'report/cell/training_zones'
    _(custom[2][:index]).must_equal 2

    # add element
    result = User::Operation::EditObj.({ id: user.id, 'type' => 'VO2max summary', 'index' => '0' }, 'current_user' => user)
    _(result.success?).must_equal true
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']

    _(default.size).must_equal 4
    _(custom.size).must_equal 4
    _(custom[0][:type]).must_equal 'report/cell/summary_table'
    _(custom[0][:index]).must_equal 0
    _(custom[1][:type]).must_equal 'report/cell/chart'
    _(custom[1][:index]).must_equal 1
    _(custom[2][:type]).must_equal 'report/cell/summary_table'
    _(custom[2][:index]).must_equal 2
    _(custom[3][:type]).must_equal 'report/cell/training_zones'
    _(custom[3][:index]).must_equal 3

    # edit first table
    _(custom[0][:title]).must_equal 'VO2max Test Summary'
    _(custom[0][:params_list]).must_equal 't,RQ,VO2,VO2/Kg,HR,Power,Revolution'
    _(custom[0][:params_unm_list]).must_equal 'mm:ss,-,l/min,ml/min/Kg,bpm,watt,BPM'
    result = User::Operation::UpdateTable.(
      {
        id: user.id,
        'edit_table' => '0',
        'title' => 'Test Sum',
        'params_list' => 't,RQ,VO2,VO2/Kg',
        'unm_list' => 'mm:ss,-,l/min,ml/min/Kg'
      },
      'current_user' => user
    )
    _(result.success?).must_equal true
    custom = User.find(user.id).content['report_template']['custom']
    _(custom[0][:title]).must_equal 'Test Sum'
    _(custom[0][:params_list]).must_equal 't,RQ,VO2,VO2/Kg'
    _(custom[0][:params_unm_list]).must_equal 'mm:ss,-,l/min,ml/min/Kg'

    # check that default is correct
    _(default[0][:type]).must_equal 'report/cell/chart'
    _(default[0][:index]).must_equal 0
    _(default[1][:type]).must_equal 'report/cell/chart'
    _(default[1][:index]).must_equal 1
    _(default[2][:type]).must_equal 'report/cell/summary_table'
    _(default[2][:index]).must_equal 2
    _(default[3][:type]).must_equal 'report/cell/training_zones'
    _(default[3][:index]).must_equal 3
  end

  it 'edit template errors' do
    _(user.email).must_equal 'test@email.com'

    # move up
    result = User::Operation::EditObj.({ id: user.id, 'move_up' => '' }, 'current_user' => user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:move_up=>["Operation not possible"]}'
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']
    _((custom == default)).must_equal true

    # move down
    result = User::Operation::EditObj.({ id: user.id, 'move_down' => '' }, 'current_user' => user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:move_down=>["Operation not possible"]}'
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']
    _((custom == default)).must_equal true

    # edit
    result = User::Operation::EditObj.({ id: user.id, 'edit_chart' => '' }, 'current_user' => user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:edit_chart=>["Operation not possible"]}'
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']
    _((custom == default)).must_equal true

    # edit chart
    result = User::Operation::UpdateChart.(
      {
        id: user.id,
        'edit_chart' => '0',
        'y1_select' => 'some',
        'y1_scale' => '0',
        'y2_scale' => '0',
        'y3_scale' => '0'
      },
      'current_user' => user
    )
    _(result.success?).must_equal false
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:y1_scale=>["Please show at least one Y '\
      'scale"], :y2_scale=>["Please show at least one Y scale"], :y3_scale=>["Please show at least one Y scale"]}'
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']
    _((custom == default)).must_equal true

    # edit table
    result = User::Operation::UpdateTable.(
      { id: user.id, 'edit_table' => '0', 'params_list' => '', 'unm_list' => '' },
      'current_user' => user
    )
    _(result.success?).must_equal false
    _(result['result.contract.default'].errors.messages.inspect).must_equal "{:params_list=>[\"Can't be blank\", "\
      '"The number of the element in the parameters and the unit of measurement list must be the same. If no '\
      'unit of measurement is required please use a dash (-) instead", "One of the paramemter is not in the '\
      "possible list or the spelling is wrong (case sensitive)\"], :unm_list=>[\"Can't be blank\", \"The number"\
      ' of the element in the parameters and the unit of measurement list must be the same. If no unit of measurement'\
      ' is required please use a dash (-) instead"]}'
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']
    _((custom == default)).must_equal true

    # delete
    result = User::Operation::EditObj.({ id: user.id, 'delete' => '' }, 'current_user' => user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:delete=>["Operation not possible"]}'
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']
    _((custom == default)).must_equal true

    # add
    result = User::Operation::EditObj.({ id: user.id, 'type' => 2, 'index' => '' }, 'current_user' => user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:type=>["must be a string"], '\
      ':index=>["Operation not possible"]}'
    custom = User.find(user.id).content['report_template']['custom']
    default = User.find(user.id).content['report_template']['default']
    _((custom == default)).must_equal true
  end
end

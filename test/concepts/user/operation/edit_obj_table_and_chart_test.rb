# frozen_string_literal: true

require 'test_helper'
require_dependency 'user/contract/edit_template.rb'

class UserOperationEditObjTest < MiniTest::Spec
  let(:admin) { create(:user, :admin) }
  let(:user) { trb_create(:user, :with_password) }
  let(:user2) { create(:user, email: 'test2@email.com') }
  let(:subject) { create(:subject, user: user) }

  let(:default_params) { { password: 'password', confirm_password: 'password' } }
  let(:expected_attrs) { { email: 'test@email.com' } }

  it 'only current user can edit custom template successfully' do
    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::EditObj.(
        params: { id: user.id },
        current_user: user2
      )
    end

    # move up third element
    result = User::Operation::EditObj.(params: { id: user.id, 'move_up' => '2' }, current_user: user)
    _(result.success?).must_equal true
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']

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
    result = User::Operation::EditObj.(params: { id: user.id, 'move_down' => '1' }, current_user: user)
    _(result.success?).must_equal true
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']

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
      params: {
        id: user.id,
        'title' => 'newTitle',
        'edit_chart' => '0',
        'y1_select' => 'something',
        'y2_select' => 'something2',
        'y1_scale' => '1'
      },
      current_user: user
    )
    _(result.success?).must_equal true
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']

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
    result = User::Operation::EditObj.(params: { id: user.id, 'delete' => '0' }, current_user: user)
    _(result.success?).must_equal true
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']

    _(default.size).must_equal 4
    _(custom.size).must_equal 3
    _(custom[0][:type]).must_equal 'report/cell/chart'
    _(custom[0][:index]).must_equal 0
    _(custom[1][:type]).must_equal 'report/cell/summary_table'
    _(custom[1][:index]).must_equal 1
    _(custom[2][:type]).must_equal 'report/cell/training_zones'
    _(custom[2][:index]).must_equal 2

    # add element
    result = User::Operation::EditObj.(params: { id: user.id, 'type' => 'VO2max summary', 'index' => '0' }, current_user: user)
    _(result.success?).must_equal true
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']

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
      params: {
        id: user.id,
        'edit_table' => '0',
        'title' => 'Test Sum',
        'params_list' => 't,RQ,VO2,VO2/Kg',
        'unm_list' => 'mm:ss,-,l/min,ml/min/Kg'
      },
      current_user: user
    )
    _(result.success?).must_equal true
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']

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
    # move up
    result = User::Operation::EditObj.(params: { id: user.id, 'move_up' => '' }, current_user: user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:move_up=>["Operation not possible"]}'
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']
    _((custom == default)).must_equal true

    # move down
    result = User::Operation::EditObj.(params: { id: user.id, 'move_down' => '' }, current_user: user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:move_down=>["Operation not possible"]}'
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']
    _((custom == default)).must_equal true

    # edit
    result = User::Operation::EditObj.(params: { id: user.id, 'edit_chart' => '' }, current_user: user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:edit_chart=>["Operation not possible"]}'
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']
    _((custom == default)).must_equal true

    # edit chart
    result = User::Operation::UpdateChart.(
      params: {
        id: user.id,
        'edit_chart' => '0',
        'y1_select' => 'some',
        'y1_scale' => '0',
        'y2_scale' => '0',
        'y3_scale' => '0'
      },
      current_user: user
    )
    _(result.success?).must_equal false
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:y1_scale=>["Please show at least one Y '\
      'scale"], :y2_scale=>["Please show at least one Y scale"], :y3_scale=>["Please show at least one Y scale"]}'
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']
    _((custom == default)).must_equal true

    # edit table
    result = User::Operation::UpdateTable.(
      params: { id: user.id, 'edit_table' => '0', 'params_list' => '', 'unm_list' => '' },
      current_user: user
    )
    _(result.success?).must_equal false
    _(result['result.contract.default'].errors.messages.inspect).must_equal "{:params_list=>[\"Can't be blank\", "\
      '"The number of the element in the parameters and the unit of measurement list must be the same. If no '\
      'unit of measurement is required please use a dash (-) instead", "One of the paramemter is not in the '\
      "possible list or the spelling is wrong (case sensitive)\"], :unm_list=>[\"Can't be blank\", \"The number"\
      ' of the element in the parameters and the unit of measurement list must be the same. If no unit of measurement'\
      ' is required please use a dash (-) instead"]}'
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']
    _((custom == default)).must_equal true

    # delete
    result = User::Operation::EditObj.(params: { id: user.id, 'delete' => '' }, current_user: user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:delete=>["Operation not possible"]}'
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']
    _((custom == default)).must_equal true

    # add
    result = User::Operation::EditObj.(params: { id: user.id, 'type' => 2, 'index' => '' }, current_user: user)
    _(result.failure?).must_equal true
    _(result['result.contract.default'].errors.messages.inspect).must_equal '{:type=>["must be a string"], '\
      ':index=>["Operation not possible"]}'
    custom = result[:model].content['report_template']['custom']
    default = result[:model].content['report_template']['default']
    _((custom == default)).must_equal true
  end
end

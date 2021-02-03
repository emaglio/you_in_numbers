# frozen_string_literal: true

require 'test_helper.rb'

class UserOperationBlockTest < MiniTest::Spec
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

  it 'only admin can block user' do
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'

    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::Block.(
        { id: user.id,
          block: 'true' },
          'current_user' => user2
      )
    end

    op = User::Operation::Block.({ id: user.id, 'block' => 'true' }, 'current_user' => admin)
    _(op.success?).must_equal true
    _(op['model'].block).must_equal true
  end
end

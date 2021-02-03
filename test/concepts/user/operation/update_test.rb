# frozen_string_literal: true

require 'test_helper.rb'

class UserOperationUpdateTest < MiniTest::Spec
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

  it 'only current_user can modify user' do
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'

    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::Update.(
        {
          id: user.id,
          email: 'newtest@email.com'
        },
          'current_user' => user2
      )
    end

    res = User::Operation::Update.({ id: user.id, email: 'newtest@email.com' }, 'current_user' => user)
    _(res.success?).must_equal true
    _(res['model'].email).must_equal 'newtest@email.com'
  end
end

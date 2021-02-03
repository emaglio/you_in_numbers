# frozen_string_literal: true

require 'test_helper.rb'

class UserOperationChangePasswordTest < MiniTest::Spec
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

  it 'wrong input change password' do
    user = User::Operation::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    _(user.success?).must_equal true

    res = User::Operation::ChangePassword.(
      {
        email: 'wrong@email.com',
        password: 'new_password',
        new_password: 'new_password',
        confirm_new_password: 'wrong_password'
      }, 'current_user' => user['model']
    )
    _(res.failure?).must_equal true
    _(res['result.contract.default'].errors.messages.inspect).must_equal '{:email=>["User not found"], ' \
      ":password=>[\"Wrong Password\"], :new_password=>[\"New password can't match the old one\"], "\
      ':confirm_new_password=>["The New Password is not matching"]}'
  end

  it 'only current_user can change password' do
    _(user.email).must_equal 'test@email.com'
    _(user2.email).must_equal 'test2@email.com'

    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::ChangePassword.(
        { email: user.email,
          password: 'password',
          new_password: 'new_password',
          confirm_new_password: 'new_password' },
          'current_user' => user2
      )
    end

    op = User::Operation::ChangePassword.(
      {
        email: user.email,
        password: 'password',
        new_password: 'new_password',
        confirm_new_password: 'new_password'
      }, 'current_user' => user
    )
    _(op.success?).must_equal true

    user_updated = User.find_by(email: user.email)

    assert Tyrant::Authenticatable.new(user_updated).digest != 'password'
    assert Tyrant::Authenticatable.new(user_updated).digest == 'new_password'
    _(Tyrant::Authenticatable.new(user_updated).confirmed?).must_equal true
    _(Tyrant::Authenticatable.new(user_updated).confirmable?).must_equal false
  end
end

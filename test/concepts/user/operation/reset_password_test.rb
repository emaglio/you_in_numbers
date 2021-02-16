# frozen_string_literal: true

require 'test_helper'

class UserOperationResetPasswordTest < MiniTest::Spec
  let(:admin) { admin_for }
  let(:user2) { User::Operation::Create.(params: { email: 'test2@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:subject) do
    Subject::Operation::Create.(
      params: {
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
      current_user: user
    )[:model]
  end

  let(:default_params) { { password: 'password', confirm_password: 'password' } }
  let(:expected_attrs) { { email: 'test@email.com' } }
  let(:user) { User::Operation::Create.(params: default_params.merge(expected_attrs))[:model] }

  it 'reset password' do
    res = User::Operation::Create.(params: { email: 'test@email.com', password: 'password', confirm_password: 'password' })
    _(res.success?).must_equal true

    result = User::Operation::ResetPassword.(params: { email: res['model'].email }, via: :test)
    _(result.success?).must_equal true

    user = User.find_by(email: res['model'].email)

    assert Tyrant::Authenticatable.new(user).digest != 'password'
    assert Tyrant::Authenticatable.new(user).digest == 'NewPassword'
    _(Tyrant::Authenticatable.new(user).confirmed?).must_equal true
    _(Tyrant::Authenticatable.new(user).confirmable?).must_equal false

    _(Mail::TestMailer.deliveries.last.to).must_equal ['test@email.com']
  end
end

# frozen_string_literal: true

require 'test_helper'

class UserOperationChangePasswordTest < MiniTest::Spec
  let(:user) { trb_create(:user, password: 'password', confirm_password: 'password') }
  let(:user2) { create(:user) }

  it 'wrong input change password' do
    res = User::Operation::ChangePassword.(
      params: {
        email: 'wrong@email.com',
        password: 'new_password',
        new_password: 'new_password',
        confirm_new_password: 'wrong_password'
      }, current_user: user
    )
    _(res.failure?).must_equal true
    _(res['result.contract.default'].errors.messages.inspect).must_equal '{:email=>["User not found"], ' \
      ":password=>[\"Wrong Password\"], :new_password=>[\"New password can't match the old one\"], "\
      ':confirm_new_password=>["The New Password is not matching"]}'
  end

  it 'only current_user can change password' do
    _(user.email).wont_equal user2.email
    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::ChangePassword.(
        params: {
          email: user.email,
          password: 'password',
          new_password: 'new_password',
          confirm_new_password: 'new_password'
        },
        current_user: user2
      )
    end

    op = User::Operation::ChangePassword.(
      params: {
        email: user.email,
        password: 'password',
        new_password: 'new_password',
        confirm_new_password: 'new_password'
      }, current_user: user
    )
    _(op.success?).must_equal true

    user_updated = User.find_by(email: user.email)

    assert Tyrant::Authenticatable.new(user_updated).digest != 'password'
    assert Tyrant::Authenticatable.new(user_updated).digest == 'new_password'
    _(Tyrant::Authenticatable.new(user_updated).confirmed?).must_equal true
    _(Tyrant::Authenticatable.new(user_updated).confirmable?).must_equal false
  end
end

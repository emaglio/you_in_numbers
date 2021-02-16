# frozen_string_literal: true

require 'test_helper'

class SubjectOperationTest < MiniTest::Spec
  let(:user) { User::Operation::Create.(params: { email: 'test@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:user2) { User::Operation::Create.(params: { email: 'test2@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:subject) do
    factory(
      Subject::Operation::Create,
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
      }, current_user: user
    )[:model]
  end

  it 'edit height and weight' do
    assert_raises ApplicationController::NotAuthorizedError do
      Subject::Operation::EditHeightWeight.(
        params: {
          id: subject.id,
          height: '180',
          weight: '80'
        },
        current_user: user2
      )
    end

    result = Subject::Operation::EditHeightWeight.(
      params: { id: subject.id, height: '200', weight: '100' },
      current_user: user
    )
    _(result.success?).must_equal true
    subject.reload
    _(subject.height).must_equal 200
    _(subject.weight).must_equal 100
  end
end

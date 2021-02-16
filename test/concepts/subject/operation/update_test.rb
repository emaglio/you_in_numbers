# frozen_string_literal: true

require 'test_helper'

class SubjectOperationUpdateTest < MiniTest::Spec
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

  it 'only owner can update subject' do
    assert_raises ApplicationController::NotAuthorizedError do
      Subject::Operation::Update.(
        params: {
          id: subject.id,
          firstname: 'NewName',
          dob: '01/01/1980'
        },
        current_user: user2
      )
    end

    result = Subject::Operation::Update.(
      params: { id: subject.id, firstname: 'NewEma', dob: '01/01/1980' },
      current_user: user
    )
    _(result.success?).must_equal true
    subject.reload
    _(subject.firstname).must_equal 'NewEma'
    _(subject.lastname).must_equal 'Maglio'
  end
end

# frozen_string_literal: true

require 'test_helper'

class SubjectOperationUpdateTest < MiniTest::Spec
  it 'only owner can update subject' do
    user = User::Operation::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    _(user.success?).must_equal true
    user2 = User::Operation::Create.(email: 'tes2t@email.com', password: 'password', confirm_password: 'password')

    subject = Subject::Operation::Create.({
                                            user_id: user['model'].id,
                                            firstname: 'Ema',
                                            lastname: 'Maglio',
                                            gender: 'Male',
                                            dob: '01/01/1980',
                                            height: '180',
                                            weight: '80',
                                            phone: '912873',
                                            email: 'ema@email.com'
                                          }, 'current_user' => user)
    _(subject.success?).must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Subject::Operation::Update.(
        { id: subject['model'].id,
          firstname: 'NewName',
          dob: '01/01/1980' },
        'current_user' => user2['model']
      )
    end

    result = Subject::Operation::Update.(
      { id: subject['model'].id, firstname: 'NewEma', dob: '01/01/1980' },
      'current_user' => user['model']
    )
    _(result.success?).must_equal true
    _(result['model'].firstname).must_equal 'NewEma'
    _(result['model'].lastname).must_equal 'Maglio'
  end
end

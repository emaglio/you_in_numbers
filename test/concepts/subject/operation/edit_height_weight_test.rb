# frozen_string_literal: true

require 'test_helper'

class SubjectOperationTest < MiniTest::Spec
  it 'edit height and weight' do
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
      Subject::Operation::EditHeightWeight.(
        {
          id: subject['model'].id,
          height: '180',
          weight: '80'
        },
        'current_user' => user2['model']
      )
    end

    result = Subject::Operation::EditHeightWeight.(
      { id: subject['model'].id, height: '200', weight: '100' },
      'current_user' => user['model']
    )
    _(result.success?).must_equal true
    _(result['model'].height).must_equal 200
    _(result['model'].weight).must_equal 100
  end
end

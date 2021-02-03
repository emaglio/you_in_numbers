# frozen_string_literal: true

require 'test_helper'

class CompanyOperationUpdateTest < MiniTest::Spec
  it "only the Company's owner can edit it" do
    user = User::Operation::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')['model']
    user2 = User::Operation::Create.(email: 'test2@email.com', password: 'password', confirm_password: 'password')['model']

    company = Company::Operation::Create.({ user_id: user.id, name: 'Company User 1' }, 'current_user' => user)
    _(company.success?).must_equal true
    _(company['model'].name).must_equal 'Company User 1'

    assert_raises ApplicationController::NotAuthorizedError do
      Company::Operation::Update.(
        { id: company['model'].id,
          name: 'NewTitle' },
        'current_user' => user2
      )
    end

    result = Company::Operation::Update.({ id: company['model'].id, name: 'My new company name' }, 'current_user' => user)
    _(result.success?).must_equal true
    _(result['model'].name).must_equal 'My new company name'
  end
end

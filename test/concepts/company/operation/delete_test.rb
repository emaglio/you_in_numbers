# frozen_string_literal: true

require 'test_helper'

class CompanyOperationDeleteTest < MiniTest::Spec
  it "only the Company's owner can delete it" do
    user = User::Operation::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')['model']
    user2 = User::Operation::Create.(email: 'test2@email.com', password: 'password', confirm_password: 'password')['model']

    company = Company::Operation::Create.({ user_id: user.id, name: 'Company User 1' }, 'current_user' => user)
    _(company.success?).must_equal true
    _(company['model'].name).must_equal 'Company User 1'

    assert_raises ApplicationController::NotAuthorizedError do
      Company::Operation::Delete.(
        { id: company['model'].id },
        'current_user' => user2
      )
    end

    result = Company::Operation::Delete.({ id: company['model'].id }, 'current_user' => user)
    _(result.success?).must_equal true
  end
end

# frozen_string_literal: true

require 'test_helper'

class CompanyOperationDeleteTest < MiniTest::Spec
  let(:user) { User::Operation::Create.(params: { email: 'test@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:user2) { User::Operation::Create.(params: { email: 'test2@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:company) { factory(Company::Operation::Create, { params: { user_id: user.id, name: 'Company User 1' }, current_user: user }) }

  it "only the Company's owner can delete it" do
    assert_raises ApplicationController::NotAuthorizedError do
      Company::Operation::Delete.(
        params: { id: company['model'].id },
        current_user: user2
      )
    end

    result = Company::Operation::Delete.(params: { id: company['model'].id }, current_user: user)
    _(result.success?).must_equal true
  end
end

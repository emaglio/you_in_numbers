# frozen_string_literal: true

require 'test_helper'

class CompanyOperationUpdateTest < MiniTest::Spec
  let(:user) { User::Operation::Create.(params: { email: 'test@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:user2) { User::Operation::Create.(params: { email: 'test2@email.com', password: 'password', confirm_password: 'password' })[:model] }
  let(:company) { factory(Company::Operation::Create, { params: { user_id: user.id, name: 'Company User 1' }, current_user: user })[:model] }

  it "only the Company's owner can edit it" do
    assert_raises ApplicationController::NotAuthorizedError do
      Company::Operation::Update.(
        params: { id: company.id, name: 'NewTitle' },
        current_user: user2
      )
    end

    result = Company::Operation::Update.(
      params: { id: company.id, name: 'My new company name' },
      current_user: user
    )
    _(result.success?).must_equal true
    _(result[:model].name).must_equal 'My new company name'
  end
end

# frozen_string_literal: true

require 'test_helper'

class UserOperationDeleteTest < MiniTest::Spec
  let(:admin) { create(:user, :admin) }
  let(:user) { trb_create(:user, :with_password) }
  let(:subject) { create(:subject, user: user) }
  let!(:company) { create(:company, user: user) }
  let!(:reports) { create_list(:report, 2, user: user) }
  let(:user2) { create(:user) }

  it 'only current_user can delete user' do
    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::Delete.(
        params: { id: user.id },
        current_user: user2
      )
    end

    res = User::Operation::Delete.(params: { id: user.id }, current_user: user)
    _(res.success?).must_equal true
  end

  it 'delete Company, Reports and Subjects if delete User' do
    assert user.company.present?
    _(user.reports.count).must_equal 2

    result = User::Operation::Delete.(params: { id: user.id }, current_user: user)
    assert result.success?

    _(Company.where(user_id: user.id).size).must_equal 0
    _(Report.where(user_id: user.id).size).must_equal 0
    _(Subject.where(user_id: user.id).size).must_equal 0
  end
end

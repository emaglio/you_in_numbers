# frozen_string_literal: true

require 'test_helper'

class UserOperationBlockTest < MiniTest::Spec
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  it 'only admin can block user' do
    assert_raises ApplicationController::NotAuthorizedError do
      User::Operation::Block.(
        params: { id: user.id, block: 'true' },
        current_user: user2
      )
    end

    op = User::Operation::Block.(params: { id: user.id, block: 'true' }, current_user: admin)
    _(op.success?).must_equal true
    user.reload
    _(user.block?).must_equal true
  end
end

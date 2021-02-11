# frozen_string_literal: true

require 'test_helper'

class CompanyOperationCreateTest < MiniTest::Spec
  it 'successfully create Company' do
    user = User::Operation::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    _(user.success?).must_equal true

    result = Company::Operation::Create.(
      params: {
        user_id: user['model'].id,
        name: 'My Company',
        address_1: 'address 1',
        address_2: 'address 2',
        city: 'Freshwater',
        postcode: '2096',
        country: 'Australia',
        email: 'company@email.com',
        phone: '12345',
        website: 'wwww.company.com.au'
      },
      current_user: user['model']
    )
    _(result.success?).must_equal true
    _(result[:model].name).must_equal 'My Company'
    _(result[:model].address_1).must_equal 'address 1'
    _(result[:model].address_2).must_equal 'address 2'
    _(result[:model].city).must_equal 'Freshwater'
    _(result[:model].postcode).must_equal '2096'
    _(result[:model].country).must_equal 'Australia'
    _(result[:model].email).must_equal 'company@email.com'
    _(result[:model].phone).must_equal '12345'
    _(result[:model].website).must_equal 'wwww.company.com.au'
    _(result[:model].user_id).must_equal user['model'].id
  end

  it 'create only if singed_in' do
    assert_raises ApplicationController::NotSignedIn do
      Company::Operation::Create.(
        params: { user_id: 1, name: 'NewTitle' },
        current_user: nil
      )
    end
  end

  it 'wrong input' do
    user = User::Operation::Create.(email: 'test@email.com', password: 'password', confirm_password: 'password')
    _(user.success?).must_equal true

    result = Company::Operation::Create.(params: {}, current_user: user)
    _(result[:'result.contract.default'].errors.messages.inspect).must_equal "{:user_id=>[\"Can't be blank\"],"\
      " :name=>[\"Can't be blank\"]}"
  end
end

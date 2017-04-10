require 'test_helper.rb'

class CompanyOperationTest < MiniTest::Spec

  it "successfully create Company" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    user.success?.must_equal true

    result = Company::Create.({ user_id: user["model"].id, name: "My Company", address_1: "address 1", address_2: "address 2", city: "Freshwater", postcode: "2096", country: "Australia",
                                email: "company@email.com", phone: "12345", website: "wwww.company.com.au"
                              }, "current_user" => user["model"])
    result.success?.must_equal true
    result["model"].name.must_equal "My Company"
    result["model"].address_1.must_equal "address 1"
    result["model"].address_2.must_equal "address 2"
    result["model"].city.must_equal "Freshwater"
    result["model"].postcode.must_equal "2096"
    result["model"].country.must_equal "Australia"
    result["model"].email.must_equal "company@email.com"
    result["model"].phone.must_equal "12345"
    result["model"].website.must_equal "wwww.company.com.au"
    result["model"].user_id.must_equal user["model"].id
  end

  it "create only if singed_in" do

    assert_raises ApplicationController::NotAuthorizedError do
      Company::Create.(
        {user_id: 1,
        name: "NewTitle"},
        "current_user" => nil)
    end

  end

  it "only the Company's owner can edit it" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})["model"]
    user2 = User::Create.({email: "test2@email.com", password: "password", confirm_password: "password"})["model"]

    company = Company::Create.({user_id: user.id, name: "Company User 1"}, "current_user" => user)
    company.success?.must_equal true
    company["model"].name.must_equal "Company User 1"

    assert_raises ApplicationController::NotAuthorizedError do
      Company::Update.(
        {id: company["model"].id,
        name: "NewTitle"},
        "current_user" => user2)
    end

    result = Company::Update.({id: company["model"].id, name: "My new company name"}, "current_user" => user)
    result.success?.must_equal true
    result["model"].name.must_equal "My new company name"
  end

    it "only the Company's owner can delete it" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})["model"]
    user2 = User::Create.({email: "test2@email.com", password: "password", confirm_password: "password"})["model"]

    company = Company::Create.({user_id: user.id, name: "Company User 1"}, "current_user" => user)
    company.success?.must_equal true
    company["model"].name.must_equal "Company User 1"

    assert_raises ApplicationController::NotAuthorizedError do
      Company::Delete.(
        {id: company["model"].id},
        "current_user" => user2)
    end

    result = Company::Delete.({id: company["model"].id}, "current_user" => user)
    result.success?.must_equal true
  end


end

require 'test_helper.rb'

class SubjectOperationTest < MiniTest::Spec

  it "create only if singed_in" do

    assert_raises ApplicationController::NotSignedIn do
      Subject::Create.(
        {user_id: 1,
        name: "NewTitle"},
        "current_user" => nil)
    end

  end

  it "wrong input" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    user.success?.must_equal true

    result = Subject::Create.({}, "current_user" => user)
    result["result.contract.default"].errors.messages.inspect.must_equal "{:user_id=>[\"must be filled\"], :firstname=>[\"must be filled\"], :lastname=>[\"must be filled\"], :gender=>[\"must be filled\"], :dob=>[\"must be filled\", \"Subject is less than 5, double check DOB.\"], :height=>[\"must be filled\", \"This must be greater than zero\"], :weight=>[\"must be filled\", \"This must be greater than zero\"]}"
  end

  it "create successfully" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    user.success?.must_equal true

    result = Subject::Create.({
                                user_id: user["model"].id,
                                firstname: "Ema",
                                lastname: "Maglio",
                                gender: "Male",
                                dob: "01/01/1980",
                                height: "180",
                                weight: "80",
                                phone: "912873",
                                email: "ema@email.com"
                                }, "current_user" => user)
    result.success?.must_equal true
    result["model"].firstname.must_equal "Ema"
    result["model"].lastname.must_equal "Maglio"
    result["model"].gender.must_equal "Male"
    result["model"].dob.must_equal DateTime.parse("01/01/1980")
    result["model"].height.must_equal 180
    result["model"].weight.must_equal 80
    result["model"].phone.must_equal "912873"
    result["model"].email.must_equal "ema@email.com"
  end

end

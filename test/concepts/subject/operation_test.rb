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
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:email=>[\"Wrong format\"], :user_id=>[\"Can't be blank\"], :firstname=>[\"Can't be blank\"], :lastname=>[\"Can't be blank\"], :gender=>[\"Can't be blank\"], :dob=>[\"Can't be blank\", \"Wrong age, Subject must be between 5 and 120 years old\"], :height=>[\"Can't be blank\", \"This must be greater than zero\"], :weight=>[\"Can't be blank\", \"This must be greater than zero\"]}"
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

  it "unique subject and email" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    user.success?.must_equal true

    subject = Subject::Create.({
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
    subject.success?.must_equal true


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
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:email=>[\"This email has been already used\"], :firstname=>[\"Subject already present in the database\"]}"
  end

  it "age between 5 and 120" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    user.success?.must_equal true

    now = DateTime.now

    year_4_old = now - (365*4)
    year_121_old = now - (365*121)

    result = Subject::Create.({
                                user_id: user["model"].id,
                                firstname: "Ema",
                                lastname: "Maglio",
                                gender: "Male",
                                dob: year_4_old.strftime("%d/%m/%Y"),
                                height: "180",
                                weight: "80",
                                phone: "912873",
                                email: "ema@email.com"
                                }, "current_user" => user)
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:dob=>[\"Wrong age, Subject must be between 5 and 120 years old\"]}"

    result = Subject::Create.({
                                user_id: user["model"].id,
                                firstname: "Ema",
                                lastname: "Maglio",
                                gender: "Male",
                                dob: year_121_old.strftime("%d/%m/%Y"),
                                height: "180",
                                weight: "80",
                                phone: "912873",
                                email: "ema@email.com"
                                }, "current_user" => user)
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:dob=>[\"Wrong age, Subject must be between 5 and 120 years old\"]}"
  end

  it "only owner can update subject" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    user.success?.must_equal true
    user2 = User::Create.({email: "tes2t@email.com", password: "password", confirm_password: "password"})

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


  end

end

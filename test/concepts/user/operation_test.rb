require 'test_helper.rb'

class UserOperationTest < MiniTest::Spec

  let(:admin) {admin_for}
  let(:user) {(User::Create.({email: "test@email.com", password: "password", confirm_password: "password"}))["model"]}
  let(:user2) {(User::Create.({email: "test2@email.com", password: "password", confirm_password: "password"}))["model"]}

  it "validate correct input" do
    result = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    result.success?.must_equal true
    result["model"].email.must_equal "test@email.com"
  end

  it "wrong input" do
    result = User::Create.({})
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:email=>[\"must be filled\", \"Wrong format\"], :password=>[\"must be filled\"], :confirm_password=>[\"must be filled\"]}"
  end

  it "passwords not matching" do
    res = User::Create.({email: "test@email.com", password: "password", confirm_password: "notpassword"})
    res.failure?.must_equal true
    res["result.contract.default"].errors.messages.inspect.must_equal "{:confirm_password=>[\"Passwords are not matching\"]}"
  end

  it "unique user" do
    res = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    res.success?.must_equal true
    res["model"].email.must_equal "test@email.com"


    res = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    res.failure?.must_equal true
    res["result.contract.default"].errors.messages.inspect.must_equal "{:email=>[\"This email has been already used\"]}"
  end

  it "only current_user can modify user" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    assert_raises ApplicationController::NotAuthorizedError do
      User::Update.(
        {id: user.id,
        email: "newtest@email.com"},
        "current_user" => user2)
    end

    res = User::Update.({id: user.id, email: "newtest@email.com"}, "current_user" => user)
    res.success?.must_equal true
    res["model"].email.must_equal "newtest@email.com"
  end

  it "only current_user can delete user" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    assert_raises ApplicationController::NotAuthorizedError do
      User::Delete.(
        {id: user.id},
        "current_user" => user2)
    end

    res = User::Delete.({id: user.id}, "current_user" => user)
    res.success?.must_equal true
  end

  it "reset password" do 
    res = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    res.success?.must_equal true

    new_password = -> { "NewPassword" }
    Tyrant::ResetPassword.({email: res["model"].email}, "generator" => new_password, "via" => :test)

    user = User.find_by(email: res["model"].email)

    assert Tyrant::Authenticatable.new(user).digest != "password"
    assert Tyrant::Authenticatable.new(user).digest == "NewPassword"
    Tyrant::Authenticatable.new(user).confirmed?.must_equal true
    Tyrant::Authenticatable.new(user).confirmable?.must_equal false

    Mail::TestMailer.deliveries.last.to.must_equal ["test@email.com"]
    Mail::TestMailer.deliveries.last.body.raw_source.must_equal "Hi there, here is your temporary password: NewPassword. We suggest you to modify this password ASAP. Cheers" 
  end

  it "wrong input change password" do 
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    user.success?.must_equal true

    res = User::ChangePassword.({email: "wrong@email.com", password: "new_password", new_password: "new_password", confirm_new_password: "wrong_password"}, "current_user" => user["model"])
    res.failure?.must_equal true
    res["result.contract.default"].errors.messages.inspect.must_equal "{:email=>[\"User not found\"], :password=>[\"Wrong Password\"], :new_password=>[\"New password can't match the old one\"], :confirm_new_password=>[\"The New Password is not matching\"]}"
  end

  it "only current_user can change password" do 
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    assert_raises ApplicationController::NotAuthorizedError do
      User::ChangePassword.(
        {email: user.email,
        password: "password",
        new_password: "new_password",
        confirm_new_password: "new_password"},
        "current_user" => user2)
    end

    op = User::ChangePassword.({email: user.email, password: "password", new_password: "new_password", confirm_new_password: "new_password"}, "current_user" => user)
    op.success?.must_equal true

    user_updated = User.find_by(email: user.email)

    assert Tyrant::Authenticatable.new(user_updated).digest != "password"
    assert Tyrant::Authenticatable.new(user_updated).digest == "new_password"
    Tyrant::Authenticatable.new(user_updated).confirmed?.must_equal true
    Tyrant::Authenticatable.new(user_updated).confirmable?.must_equal false    
  end

  it "only admin can block user" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"  

    assert_raises ApplicationController::NotAuthorizedError do
      User::Block.(
        {id: user.id,
        block: "true"},
        "current_user" => user2)
    end

    op = User::Block.({id: user.id, block: "true"}, "current_user" => admin)
    op.success?.must_equal true 
    op["model"].block.must_equal true
  end

end
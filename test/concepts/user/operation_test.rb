require 'test_helper.rb'
require_dependency 'user/contract/edit_template.rb'

class UserOperationTest < MiniTest::Spec

  let(:admin) {admin_for}
  let(:user) {(User::Create.({email: "test@email.com", password: "password", confirm_password: "password"}))["model"]}
  let(:user2) {(User::Create.({email: "test2@email.com", password: "password", confirm_password: "password"}))["model"]}

  it "validate correct input" do
    result = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    result.success?.must_equal true
    result["model"].email.must_equal "test@email.com"
    (result["model"]["content"]["report_settings"] != nil).must_equal true
    (result["model"]["content"]["report_template"] != nil).must_equal true
  end

  it "wrong input" do
    result = User::Create.({})
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:email=>[\"Can't be blank\", \"Wrong format\"], :password=>[\"Can't be blank\"], :confirm_password=>[\"Can't be blank\"]}"
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

  it "delete Company and Reports if delete User" do
    user.email.must_equal "test@email.com"

    # create company
    company = Company::Create.({ user_id: user.id, name: "My Company"}, "current_user" => user)
    company.success?.must_equal true

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    # create 2 Reports
    report1 = Report::Create.({
          user_id: user.id,
          subject_id: 1,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report1.success?.must_equal true

    report2 = Report::Create.({
          user_id: user.id,
          subject_id: 1,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report2.success?.must_equal true

    Company.where("user_id like ?", user.id).size.must_equal 1
    Report.where("user_id like ?", user.id).size.must_equal 2

    User::Delete.({id: user.id}, "current_user" => user)

    Company.where("user_id like ?", user.id).size.must_equal 0
    Report.where("user_id like ?", user.id).size.must_equal 0
  end

  it "default settings" do
    user.email.must_equal "test@email.com"

    user.content["report_settings"].each do |key,value|
      (value.size > 0).must_equal true
    end

    user.content["report_template"].each do |key,value|
      (value.size > 0).must_equal true
    end
  end

  it "edit custom template successfully" do
    user.email.must_equal "test@email.com"

    #move up third element
    result = User::EditObj.({id: user.id, "move_up" => "2"}, "current_user" => user)
    result.success?.must_equal true
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]

    default.size.must_equal 4
    custom.size.must_equal 4
    custom[0][:type].must_equal "report/cell/chart"
    custom[0][:index].must_equal 0
    custom[1][:type].must_equal 'report/cell/vo2max_summary'
    custom[1][:index].must_equal 1
    custom[2][:type].must_equal 'report/cell/chart'
    custom[2][:index].must_equal 2
    custom[3][:type].must_equal 'report/cell/training_zones'
    custom[3][:index].must_equal 3

    #move down second element
    result = User::EditObj.({id: user.id, "move_down" => "1"}, "current_user" => user)
    result.success?.must_equal true
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]

    default.size.must_equal 4
    custom.size.must_equal 4
    custom[0][:type].must_equal "report/cell/chart"
    custom[0][:index].must_equal 0
    custom[1][:type].must_equal 'report/cell/chart'
    custom[1][:index].must_equal 1
    custom[2][:type].must_equal 'report/cell/vo2max_summary'
    custom[2][:index].must_equal 2
    custom[3][:type].must_equal 'report/cell/training_zones'
    custom[3][:index].must_equal 3

    #edit first chart
    result = User::EditObj.({id: user.id, "edit_chart" => "0", "y1_select" => "something", "y2_select" => "something2"}, "current_user" => user)
    result.success?.must_equal true
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]

    default.size.must_equal 4
    custom.size.must_equal 4
    custom[0][:type].must_equal "report/cell/chart"
    custom[0][:index].must_equal 0
    custom[0][:y1][:name].must_equal "something"
    custom[0][:y2][:name].must_equal "something2"
    custom[1][:type].must_equal 'report/cell/chart'
    custom[1][:index].must_equal 1
    custom[1][:y1][:name].must_equal "HR"
    custom[1][:y2][:name].must_equal "Power"
    custom[2][:type].must_equal 'report/cell/vo2max_summary'
    custom[2][:index].must_equal 2
    custom[3][:type].must_equal 'report/cell/training_zones'
    custom[3][:index].must_equal 3

    #delete the first chart
    result = User::EditObj.({id: user.id, "delete" => "0"}, "current_user" => user)
    result.success?.must_equal true
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]

    default.size.must_equal 4
    custom.size.must_equal 3
    custom[0][:type].must_equal "report/cell/chart"
    custom[0][:index].must_equal 0
    custom[1][:type].must_equal 'report/cell/vo2max_summary'
    custom[1][:index].must_equal 1
    custom[2][:type].must_equal 'report/cell/training_zones'
    custom[2][:index].must_equal 2

    #add element
    result = User::EditObj.({id: user.id, "type" => "VO2max summary", "index" => "0"}, "current_user" => user)
    result.success?.must_equal true
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]

    default.size.must_equal 4
    custom.size.must_equal 4
    custom[0][:type].must_equal "report/cell/vo2max_summary"
    custom[0][:index].must_equal 0
    custom[1][:type].must_equal "report/cell/chart"
    custom[1][:index].must_equal 1
    custom[2][:type].must_equal 'report/cell/vo2max_summary'
    custom[2][:index].must_equal 2
    custom[3][:type].must_equal 'report/cell/training_zones'
    custom[3][:index].must_equal 3

    # check that default is correct
    default[0][:type].must_equal "report/cell/chart"
    default[0][:index].must_equal 0
    default[1][:type].must_equal "report/cell/chart"
    default[1][:index].must_equal 1
    default[2][:type].must_equal 'report/cell/vo2max_summary'
    default[2][:index].must_equal 2
    default[3][:type].must_equal 'report/cell/training_zones'
    default[3][:index].must_equal 3
  end

  it "edit tempalte errors" do
    user.email.must_equal "test@email.com"

    #move up
    result = User::EditObj.({id: user.id, "move_up" => ""}, "current_user" => user)
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:move_up=>[\"Operation not possible\"]}"
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]
    (custom == default).must_equal true

    #move down
    result = User::EditObj.({id: user.id, "move_down" => ""}, "current_user" => user)
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:move_down=>[\"Operation not possible\"]}"
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]
    (custom == default).must_equal true

    #edit
    result = User::EditObj.({id: user.id, "edit_chart" => ""}, "current_user" => user)
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:edit_chart=>[\"Operation not possible\"]}"
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]
    (custom == default).must_equal true

    #delete
    result = User::EditObj.({id: user.id, "delete" => ""}, "current_user" => user)
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:delete=>[\"Operation not possible\"]}"
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]
    (custom == default).must_equal true

    #add
    result = User::EditObj.({id: user.id, "type" => 2, "index" => ""}, "current_user" => user)
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:type=>[\"must be a string\"], :index=>[\"Operation not possible\"]}"
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]
    (custom == default).must_equal true
  end
end

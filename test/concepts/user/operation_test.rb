require 'test_helper.rb'
require_dependency 'user/contract/edit_template.rb'

class UserOperationTest < MiniTest::Spec

  let(:admin) {admin_for}
  let(:user) {(User::Create.({email: "test@email.com", password: "password", confirm_password: "password"}))["model"]}
  let(:user2) {(User::Create.({email: "test2@email.com", password: "password", confirm_password: "password"}))["model"]}
  let(:subject) {(Subject::Create.({
                                    user_id: user.id,
                                    firstname: "Ema",
                                    lastname: "Maglio",
                                    gender: "Male",
                                    dob: "01/01/1980",
                                    height: "180",
                                    weight: "80",
                                    phone: "912873",
                                    email: "ema@email.com"}, "current_user" => user))["model"]}

  let(:params_pass) { { password: "password", confirm_password: "password" } }
  let(:attrs_pass) { { } }
  let(:email) { { email: "test@email.com" } }
  let(:user) { factory( User::Create, params_pass.merge(email))['model'] }

  describe 'valid inputs' do
    let(:report_settings) { {
      "params_list"=> ["t", "Rf", "VE", "VO2", "VCO2", "RQ", "VE/VO2", "VE/VCO2", "HR", "VO2/Kg", "FAT%", "CHO%", "Phase"],
      "ergo_params_list" => ["Power", "Watt", "Revolution", "RPM"],
      "training_zones_settings" => [35, 50, 51, 75, 76, 90, 91, 100],
      "units_of_measurement" => {"height" => "cm", "weight" => "kg"}
    } }

    let(:report_template) { { "default" => MyDefault::ReportObj.clone, "custom" => MyDefault::ReportObj.clone } }

    it { assert_pass User::Create, email, email }

    it 'populates default params' do
      assert_exposes user,
        email: 'test@email.com',
        'content' => ->(actual, **) {
          actual[:actual]['report_settings']== report_settings
          actual[:actual]['report_template']== report_template
        }
    end
  end

  describe 'empty input hash' do
    let(:params_pass) {{}}


    it do
      assert_fail User::Create, {}, {} do |result|
        assert_equal({
          :email => ["Can't be blank", "Wrong format"],
          :password => ["Can't be blank"],
          :confirm_password => ["Can't be blank"]
        }, result["contract.default"].errors.messages )
      end
    end
  end

  describe 'passwords not matching' do
    let(:params_pass) { { password: "password", confirm_password: "notpassword" } }

    it do
      assert_fail User::Create, { email: "test@email.com" }, {} do |result|
        assert_equal({
          :confirm_password => ["Passwords are not matching"]
        }, result["contract.default"].errors.messages)
      end
    end
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

    result = Tyrant::ResetPassword::Request.({email: res["model"].email}, "via" => :test, "url" => "redirect_link")
    result.success?.must_equal true

    result = Tyrant::ResetPassword::Confirm.({email: res["model"].email, safe_url: result["safe_url"], new_password: "NewPassword", confirm_new_password: "NewPassword"})
    result.success?.must_equal true

    user = User.find_by(email: res["model"].email)

    assert Tyrant::Authenticatable.new(user).digest != "password"
    assert Tyrant::Authenticatable.new(user).digest == "NewPassword"
    Tyrant::Authenticatable.new(user).confirmed?.must_equal true
    Tyrant::Authenticatable.new(user).confirmable?.must_equal false

    Mail::TestMailer.deliveries.last.to.must_equal ["test@email.com"]
  end

  it "wrong input change password" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})
    user.success?.must_equal true

    res = User::ChangePassword.({em ail: "wrong@email.com", password: "new_password", new_password: "new_password", confirm_new_password: "wrong_password"}, "current_user" => user["model"])
    res.failure?.must_equal true
    res["result.contract.default"].errors.messages.inspect.must_equal "{:email=>[\"User not found\"], :password=>[\"Wrong Password\"], :new_password=>[\"New password can't match the old one\"], :confirm_new_password=>[\"Passwords are not matching\"]}"
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

    op = User::Block.({id: user.id, "block" => "true"}, "current_user" => admin)
    op.success?.must_equal true
    op["model"].block.must_equal true
  end

  it "delete Company, Reports and Subjects if delete User" do
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
          subject_id: subject.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report1.success?.must_equal true

    report2 = Report::Create.({
          user_id: user.id,
          subject_id: subject.id,
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
    Subject.where("user_id like ?", user.id).size.must_equal 0
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

  it "only current user can edit custom template successfully" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"

    assert_raises ApplicationController::NotAuthorizedError do
      User::EditObj.(
        {id: user.id},
        "current_user" => user2)
    end

    #move up third element
    result = User::EditObj.({id: user.id, "move_up" => "2"}, "current_user" => user)
    # result["result.contract.default"].errors.messages.inspect.must_equal ""
    result.success?.must_equal true
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]

    default.size.must_equal 4
    custom.size.must_equal 4
    custom[0][:type].must_equal "report/cell/chart"
    custom[0][:index].must_equal 0
    custom[1][:type].must_equal 'report/cell/summary_table'
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
    custom[2][:type].must_equal 'report/cell/summary_table'
    custom[2][:index].must_equal 2
    custom[3][:type].must_equal 'report/cell/training_zones'
    custom[3][:index].must_equal 3

    #edit first chart
    result = User::UpdateChart.({id: user.id, "title" => "newTitle", "edit_chart" => "0", "y1_select" => "something", "y2_select" => "something2", "y1_scale" => "1"}, "current_user" => user)
    result.success?.must_equal true
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]

    default.size.must_equal 4
    custom.size.must_equal 4
    custom[0][:type].must_equal "report/cell/chart"
    custom[0][:index].must_equal 0
    custom[0][:title].must_equal "newTitle"
    custom[0][:y1][:name].must_equal "something"
    custom[0][:y2][:name].must_equal "something2"
    custom[1][:type].must_equal 'report/cell/chart'
    custom[1][:index].must_equal 1
    custom[1][:y1][:name].must_equal "HR"
    custom[1][:y2][:name].must_equal "Power"
    custom[2][:type].must_equal 'report/cell/summary_table'
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
    custom[1][:type].must_equal 'report/cell/summary_table'
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
    custom[0][:type].must_equal "report/cell/summary_table"
    custom[0][:index].must_equal 0
    custom[1][:type].must_equal "report/cell/chart"
    custom[1][:index].must_equal 1
    custom[2][:type].must_equal 'report/cell/summary_table'
    custom[2][:index].must_equal 2
    custom[3][:type].must_equal 'report/cell/training_zones'
    custom[3][:index].must_equal 3

    #edit first table
    custom[0][:title].must_equal "VO2max Test Summary"
    custom[0][:params_list].must_equal "t,RQ,VO2,VO2/Kg,HR,Power,Revolution"
    custom[0][:params_unm_list].must_equal "mm:ss,-,l/min,ml/min/Kg,bpm,watt,BPM"
    result = User::UpdateTable.({id: user.id, "edit_table" => "0", "title" => "Test Sum", "params_list" => "t,RQ,VO2,VO2/Kg", "unm_list" => "mm:ss,-,l/min,ml/min/Kg"}, "current_user" => user)
    result.success?.must_equal true
    custom = User.find(user.id).content["report_template"]["custom"]
    custom[0][:title].must_equal "Test Sum"
    custom[0][:params_list].must_equal "t,RQ,VO2,VO2/Kg"
    custom[0][:params_unm_list].must_equal "mm:ss,-,l/min,ml/min/Kg"

    # check that default is correct
    default[0][:type].must_equal "report/cell/chart"
    default[0][:index].must_equal 0
    default[1][:type].must_equal "report/cell/chart"
    default[1][:index].must_equal 1
    default[2][:type].must_equal 'report/cell/summary_table'
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

    #edit chart
    result = User::UpdateChart.({id: user.id, "edit_chart" => "0", "y1_select" => "some", "y1_scale" => "0", "y2_scale" => "0", "y3_scale" => "0"}, "current_user" => user)
    result.success?.must_equal false
    result["result.contract.default"].errors.messages.inspect.must_equal "{:y1_scale=>[\"Please show at least one Y scale\"], :y2_scale=>[\"Please show at least one Y scale\"], :y3_scale=>[\"Please show at least one Y scale\"]}"
    custom = User.find(user.id).content["report_template"]["custom"]
    default = User.find(user.id).content["report_template"]["default"]
    (custom == default).must_equal true

    #edit table
    result = User::UpdateTable.({id: user.id, "edit_table" => "0", "params_list" => "", "unm_list" => ""}, "current_user" => user)
    result.success?.must_equal false
    result["result.contract.default"].errors.messages.inspect.must_equal "{:params_list=>[\"Can't be blank\", \"The number of the element in the parameters and the unit of measurement list must be the same. If no unit of measurement is required please use a dash (-) instead\", \"One of the paramemter is not in the possible list or the spelling is wrong (case sensitive)\"], :unm_list=>[\"Can't be blank\", \"The number of the element in the parameters and the unit of measurement list must be the same. If no unit of measurement is required please use a dash (-) instead\"]}"
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

  it "report settings correct input" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"

    assert_raises ApplicationController::NotAuthorizedError do
      User::ReportSettings.(
        {id: user.id},
        "current_user" => user2)
    end

    result = User::ReportSettings.(
              {
                id: user.id,
                "params_list" => "Parms0,Parms1,Parms2,Parms3",
                "load_1" => "Load1",
                "load_1_um" => "Load1_um",
                "load_2" => "Load2",
                "load_2_um" => "Load2_um",
                "fat_burning_2" => "45",
                "endurance_1" => "55",
                "endurance_2" => "65",
                "at_1" => "75",
                "at_2" => "85",
                "vo2max_1" => "95",
                um_height: "um_h",
                um_weight: "um_w",
                }, "current_user" => user)
    result.success?.must_equal true
    result["model"].content["report_settings"]["params_list"][0].must_equal "Parms0"
    result["model"].content["report_settings"]["params_list"][1].must_equal "Parms1"
    result["model"].content["report_settings"]["params_list"][2].must_equal "Parms2"
    result["model"].content["report_settings"]["params_list"][3].must_equal "Parms3"
    result["model"].content["report_settings"]["ergo_params_list"][0].must_equal "Load1"
    result["model"].content["report_settings"]["ergo_params_list"][1].must_equal "Load1_um"
    result["model"].content["report_settings"]["ergo_params_list"][2].must_equal "Load2"
    result["model"].content["report_settings"]["ergo_params_list"][3].must_equal "Load2_um"
    result["model"].content["report_settings"]["training_zones_settings"][0].must_equal 35
    result["model"].content["report_settings"]["training_zones_settings"][1].must_equal 45
    result["model"].content["report_settings"]["training_zones_settings"][2].must_equal 55
    result["model"].content["report_settings"]["training_zones_settings"][3].must_equal 65
    result["model"].content["report_settings"]["training_zones_settings"][4].must_equal 75
    result["model"].content["report_settings"]["training_zones_settings"][5].must_equal 85
    result["model"].content["report_settings"]["training_zones_settings"][6].must_equal 95
    result["model"].content["report_settings"]["units_of_measurement"]["height"].must_equal "um_h"
    result["model"].content["report_settings"]["units_of_measurement"]["weight"].must_equal "um_w"
  end

    it "report settings wrong input" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"

    assert_raises ApplicationController::NotAuthorizedError do
      User::ReportSettings.(
        {id: user.id},
        "current_user" => user2)
    end

    result = User::ReportSettings.(
              {
                id: user.id,
                }, "current_user" => user)
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:fat_burning_2=>[\"Can't be blank\", \"This must be greater than 35\"], :endurance_1=>[\"Can't be blank\", \"This range was wrong or over the previous one\"], :endurance_2=>[\"Can't be blank\", \"This range was wrong or over the previous one\"], :at_1=>[\"Can't be blank\", \"This range was wrong or over the previous one\"], :at_2=>[\"Can't be blank\", \"This range was wrong or over the previous one\"], :vo2max_1=>[\"Can't be blank\", \"This range was wrong or over the previous one\"], :load_1=>[\"Can't be blank\"], :load_1_um=>[\"Can't be blank\"], :load_2=>[\"Can't be blank\"], :load_2_um=>[\"Can't be blank\"], :um_height=>[\"Can't be blank\"], :um_weight=>[\"Can't be blank\"]}"
  end
end

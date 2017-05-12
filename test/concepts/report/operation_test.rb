require 'test_helper.rb'

class UserOperationTest < MiniTest::Spec

  let(:admin) {admin_for}
  let(:user) {(User::Create.({email: "test@email.com", password: "password", confirm_password: "password"}))["model"]}
  let(:user2) {(User::Create.({email: "test2@email.com", password: "password", confirm_password: "password"}))["model"]}


  it "create report successfully" do
    user.email.must_equal "test@email.com"

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    report = Report::Create.({
          user_id: user.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report.success?.must_equal true

    report["model"].title.must_equal "My report"
    report["model"].content.must_equal "default"
    report["model"].user_id.must_equal user.id

    # check VO2max params and results are not empty (will see if I need to test the actual values of the results)
    report["model"]["cpet_params"].each do |key, value|
      (value.size > 0).must_equal true
    end

    report["model"]["cpet_results"].each do |key, hash|
      if key =="at_index"
        (value != nil).must_equal true
      else
        hash.each do |key, value|
          (value != nil).must_equal true
        end
      end
    end

    # check RMR params and results are not empty (will see if I need to test the actual values of the results)
    # TODO
    # report["model"]["rmr_params"].each do |key, value|
    # end

    # report["model"]["rmr_results"].each do |key, hash|
    # end


  end

  it "wrong input" do
    user.email.must_equal "test@email.com"

    result = Report::Create.({
          # user_id: user.id,
          # title: "My report",
          # cpet_file_path: upload_file,
          # template: "default"
      }, "current_user" => user)

    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:title=>[\"must be filled\"], :user_id=>[\"must be filled\"], :template=>[\"must be filled\"], :cpet_file_path=>[\"At least one file must be uploaded\"], :rmr_file_path=>[\"At least one file must be uploaded\"]}"

    result = Report::Create.({
          user_id: user.id,
          title: "My report",
          cpet_file_path: "test/files/wrong_file.xlsx",
          rmr_file_path: "test/files/wrong_file.xlsx",
          template: "default"
      }, "current_user" => user)

    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:cpet_file_path=>[\"The file selected doens't exist\"], :rmr_file_path=>[\"The file selected doens't exist\"]}"
  end

  it "only report owner can update template" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    report = Report::Create.({
          user_id: user.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report.success?.must_equal true
    report["model"].content.must_equal "default"

    result = Report::UpdateTemplate.({
        id: report["model"].id,
        content: "custom"
      }, "current_user" => user)

    result.success?.must_equal true
    result["model"].content.must_equal "custom"

    assert_raises ApplicationController::NotAuthorizedError do
      Report::UpdateTemplate.({
        id: report["model"].id,
        content: "default"
      }, "current_user" => user2)
    end

  end

  it "only report owner can delete report" do
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    report = Report::Create.({
          user_id: user.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report.success?.must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Report::Delete.({
        id: report["model"].id
        }, "current_user" => user2)
    end

    result = Report::Delete.({
        id: report["model"].id,
      }, "current_user" => user)

    result.success?.must_equal true

    Report.where("id like ?", report["model"].id).size.must_equal 0

  end

end

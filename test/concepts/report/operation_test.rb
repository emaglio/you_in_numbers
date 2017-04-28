require 'test_helper.rb'

class UserOperationTest < MiniTest::Spec

  let(:admin) {admin_for}
  let(:user) {(User::Create.({email: "test@email.com", password: "password", confirm_password: "password"}))["model"]}
  let(:user2) {(User::Create.({email: "test2@email.com", password: "password", confirm_password: "password"}))["model"]}


  it "create report successfully" do
    user = User::Create.({email: "test@email.com", password: "password", confirm_password: "password"})["model"]

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    report = Report::Create.({
          user_id: user.id,
          title: "My report",
          cpet_file_path: upload_file
      }, "current_user" => user)
    report.success?.must_equal true

    report["model"].title.must_equal "My report"
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

end

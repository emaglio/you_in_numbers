require 'test_helper.rb'

class ReportOperationTest < MiniTest::Spec

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

  it "create report successfully" do
    user.email.must_equal "test@email.com"
    subject.firstname.must_equal "Ema"

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    report = Report::Create.({
          user_id: user.id,
          subject_id: subject.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report.success?.must_equal true

    report["model"].title.must_equal "My report"
    report["model"].user_id.must_equal user.id
    report["model"].content["template"].must_equal "default"
    report["model"].content["subject"]["height"].must_equal 180
    report["model"].content["subject"]["weight"].must_equal 80

    # check VO2max params and results are not empty (will see if I need to test the actual values of the results)
    report["model"]["cpet_params"].each do |key, value|
      (value.size > 0).must_equal true
    end

    report["model"]["cpet_results"].each do |key, hash|
      if key =="at_index" or key == "edited_at_index"
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
    subject.firstname.must_equal "Ema"

    result = Report::Create.({}, "current_user" => user)

    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:title=>[\"Can't be blank\"], :user_id=>[\"Can't be blank\"], :subject_id=>[\"Can't be blank\"], :template=>[\"Can't be blank\"], :cpet_file_path=>[\"At least one file must be uploaded\"], :rmr_file_path=>[\"At least one file must be uploaded\"]}"

    # FIXME
    # wrong_file = ActionDispatch::Http::UploadedFile.new({
    #   :tempfile => File.new(Rails.root.join("test/files/wrong_file.xlsx"))
    # })

    # result = Report::Create.({
    #       user_id: user.id,
    #       subject_id: subject.id,
    #       title: "My report",
    #       cpet_file_path: wrong_file,
    #       rmr_file_path: wrong_file,
    #       template: "default"
    #   }, "current_user" => user)

    # result.failure?.must_equal true
    # result["result.contract.default"].errors.messages.inspect.must_equal "{:cpet_file_path=>[\"The file selected doens't exist\"], :rmr_file_path=>[\"The file selected doens't exist\"]}"
  end

  it "only report owner can update template" do
    admin.email.must_equal "admin@email.com" #this needs to be created because the user_id 1 is used to edit the template and DatabaseCleaner deletes it
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"
    subject.firstname.must_equal "Ema"

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    report = Report::Create.({
          user_id: user.id,
          subject_id: subject.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report.success?.must_equal true
    report["model"].content["template"].must_equal "default"

    result = Report::UpdateTemplate.({
        id: report["model"].id,
        template: "custom"
      }, "current_user" => user)
    result.success?.must_equal true
    result["model"].content["template"].must_equal "custom"

    assert_raises ApplicationController::NotAuthorizedError do
      Report::UpdateTemplate.({
        id: report["model"].id,
        template: "default"
      }, "current_user" => user2)
    end

  end

  it "only report owner can delete report" do
    admin.email.must_equal "admin@email.com" #this needs to be created because the id 1 is used to edit the template and DatabaseCleaner deletes it
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"
    subject.firstname.must_equal "Ema"

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    report = Report::Create.({
          user_id: user.id,
          subject_id: subject.id,
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

  it "generate pdf" do
    user.email.must_equal "test@email.com"
    subject.firstname.must_equal "Ema"

    company = Company::Create.({ user_id: user.id, name: "My Company", address_1: "address 1", address_2: "address 2", city: "Freshwater", postcode: "2096", country: "Australia",
                                  country: "Australia", email: "company@email.com", phone: "12345", website: "wwww.company.com.au", logo: File.open("test/images/logo.jpeg")
                                }, "current_user" => user)["model"]

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })
    report = Report::Create.({user_id: user.id, subject_id: subject.id, title: "Report", cpet_file_path: upload_file, template: "default"}, "current_user" => user)
    report.success?.must_equal true

    # TODO: need to move 4 images into the temp_file folder to test this

    # result = Report::GeneratePdf.({id: report["model"].id}, "current_user" => user)
    # result.success?.must_equal true

    Company::Delete.({id: company.id}, "current_user" => user)
  end

  it "only owner can edit AT" do
    admin.email.must_equal "admin@email.com" #this needs to be created because the id 1 is used to edit the template and DatabaseCleaner deletes it
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"
    subject.firstname.must_equal "Ema"

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    report = Report::Create.({
          user_id: user.id,
          subject_id: subject.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report.success?.must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Report::EditAt.({
        id: report["model"].id
        }, "current_user" => user2)
    end

    # check errors
    result = Report::EditAt.({id: report["model"].id}, "current_user" => user )
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:at_position=>[\"must be filled\"]}"

    at_calculated = report["model"]["cpet_results"]["at_index"]
    report["model"]["cpet_results"]["at_index"].must_equal report["model"]["cpet_results"]["edited_at_index"]

    # successfully editing AT
    result = Report::EditAt.({id: report["model"].id, "at_position" => 80}, "current_user" => user )
    result.success?.must_equal true
    result["model"]["cpet_results"]["at_index"].wont_equal result["model"]["cpet_results"]["edited_at_index"]
    result["model"]["cpet_results"]["at_index"].must_equal at_calculated
    result["model"]["cpet_results"]["edited_at_index"].must_equal 80
  end

  it "only owner can edit VO2max" do
    admin.email.must_equal "admin@email.com" #this needs to be created because the id 1 is used to edit the template and DatabaseCleaner deletes it
    user.email.must_equal "test@email.com"
    user2.email.must_equal "test2@email.com"
    subject.firstname.must_equal "Ema"

    upload_file = ActionDispatch::Http::UploadedFile.new({
      :tempfile => File.new(Rails.root.join("test/files/cpet.xlsx"))
    })

    report = Report::Create.({
          user_id: user.id,
          subject_id: subject.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
      }, "current_user" => user)
    report.success?.must_equal true

    assert_raises ApplicationController::NotAuthorizedError do
      Report::EditVO2Max.({
        id: report["model"].id
        }, "current_user" => user2)
    end

    # check errors
    result = Report::EditVO2Max.({id: report["model"].id}, "current_user" => user )
    result.failure?.must_equal true
    result["result.contract.default"].errors.messages.inspect.must_equal "{:vo2max_starts=>[\"must be filled\"], :vo2max_ends=>[\"must be filled\"], :vo2max_value=>[\"must be filled\"]}"

    vo2_starts = report["model"]["cpet_results"]["vo2_max"]["starts"]
    vo2_ends = report["model"]["cpet_results"]["vo2_max"]["ends"]
    vo2_value = report["model"]["cpet_results"]["vo2_max"]["value"]
    report["model"]["cpet_results"]["vo2_max"].must_equal report["model"]["cpet_results"]["edited_vo2_max"]

    # successfully editing VO2max
    result = Report::EditVO2Max.({id: report["model"].id, "vo2max_starts" => 40, "vo2max_ends" => 60, "vo2max_value" => 1100}, "current_user" => user )
    result.success?.must_equal true
    result["model"]["cpet_results"]["vo2_max"]["starts"].must_equal vo2_starts
    result["model"]["cpet_results"]["vo2_max"]["ends"].must_equal vo2_ends
    result["model"]["cpet_results"]["vo2_max"]["value"].must_equal vo2_value
    result["model"]["cpet_results"]["edited_vo2_max"]["index"].must_equal 60
    result["model"]["cpet_results"]["edited_vo2_max"]["starts"].must_equal 40
    result["model"]["cpet_results"]["edited_vo2_max"]["ends"].must_equal 60
    result["model"]["cpet_results"]["edited_vo2_max"]["value"].must_equal 1100
  end

end

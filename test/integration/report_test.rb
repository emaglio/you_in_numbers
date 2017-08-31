require "test_helper"

class ReportIntegrationTest < Trailblazer::Test::Integration

  describe "CRUD report" do

    it "Create report only if subject is select" do
      log_in_as_user
      user = User.find_by(email: "my@email.com")

      click_link "New Report"

      page.must_have_content "Select an existing Subject or "
      page.must_have_button "Create a new one"

      click_button "Create a new one"

      page.current_path.must_equal "/subjects/new"

      new_subject!

      visit "/reports/new?subject_id=1"

      page.must_have_content "New Report"
      page.must_have_content "Subject details"
      page.must_have_content "SubjectFirstname"
      page.must_have_content "SubjectLastname"
      page.must_have_css "#height"
      page.must_have_css "#weight"
      page.must_have_button "Save Changes"
      page.must_have_css "#title"
      page.must_have_css "#cpet_file_path"
      page.must_have_css "#rmr_file_path"
      page.must_have_css "#template"
      page.must_have_button "Create Report"

      # test error messages
      click_button "Create Report"
      page.must_have_content "At least one file must be uploaded"

      within("//form[@id='new_report']") do
        fill_in 'title', with: "ReportTitle"
        attach_file('cpet_file_path', Rails.root.join("test/files/cpet.xlsx"))
        attach_file('rmr_file_path', Rails.root.join("test/files/rmr.xlsx"))
      end
      click_button "Create Report"

      page.must_have_content "Report created"
      page.must_have_content "ReportTitle"
      page.current_path.must_equal "/reports/#{Report.last.id}"


    end

  end

end # class ReportIntegrationTest

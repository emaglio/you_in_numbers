require 'test_helper'

class SubjectIntegrationTest < Trailblazer::Test::Integration

  describe "Subject CRUD" do

    it "Create subject from scratch" do
      log_in_as_user
      user = User.find_by(email: "my@email.com")

      click_link "New Subject"
      page.current_path.must_equal "/subjects/new"

      page.must_have_content "New Subject"
      page.must_have_css "#firstname"
      page.must_have_css "#lastname"
      page.must_have_css "#gender"
      page.must_have_css "#dob"
      page.must_have_css "#height"
      page.must_have_css "#weight"
      page.must_have_css "#phone"
      page.must_have_css "#email"
      page.must_have_button "Create Subject"

      # test errors
      click_button "Create Subject"
      page.must_have_content "Can't be blank"

      # create subject successfully
      new_subject!

      page.must_have_content "Subject created"
      page.current_path.must_equal "/subjects"

      visit "/subjects/#{Subject.last.id}"

      find('#firstname').value.must_equal "SubjectFirstname"
      find('#lastname').value.must_equal "SubjectLastname"
      find('#gender').value.must_equal "Male"
      find('#dob').value.must_equal "01/Jan/1980"
      find('#height').value.must_equal "180"
      find('#weight').value.must_equal "80"
      find('#phone').value.must_equal "0128471"
      find('#email').value.must_equal "subject@email.com"
    end

    it "Only subject's owner can edit it" do
      log_in_as_user
      user = User.find_by(email: "my@email.com")

      new_subject!

      click_link "Sign Out"

      user2 = User::Create.({email: "test2@email.com", firstname: "User2", password: "password", confirm_password: "password"})["model"]
      submit!(user2.email, "password")

      visit "/subjects/#{Subject.last.id}"
      page.must_have_content "You are not authorized mate!"
      page.current_path.must_equal "/reports"

      log_in_as_user
      visit "/subjects/#{Subject.last.id}"
      click_button "Edit"

      page.must_have_content "New Subject"
      page.must_have_css "#firstname"
      page.must_have_css "#lastname"
      page.must_have_css "#gender"
      page.must_have_css "#dob"
      page.must_have_css "#height"
      page.must_have_css "#weight"
      page.must_have_css "#phone"
      page.must_have_css "#email"
      page.must_have_button "Save Changes"

      within("//form[@id='edit_subject']") do
        fill_in 'firstname', with: "NewSubjectFirstname"
      end
      click_button "Save Changes"

      page.current_path.must_equal "/subjects/#{Subject.last.id}"

      find('#firstname').value.must_equal "NewSubjectFirstname"
    end

    it "Delete Subject" do
      log_in_as_user
      user = User.find_by(email: "my@email.com")

      new_subject!

      subject_num = Subject.all.size

      visit "/subjects/#{Subject.last.id}"

      click_button "Delete"

      page.must_have_content "Subject deleted"
      Subject.all.size.must_equal (subject_num-1)
    end
  end
end

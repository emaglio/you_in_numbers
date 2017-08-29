require 'test_helper'

class UserIntegrationTest < Trailblazer::Test::Integration


  describe 'User CRUD test' do


    it "create user" do
      visit 'users/new'

      page.must_have_css "#firstname"
      page.must_have_css "#lastname"
      page.must_have_selector ("#gender")
      page.must_have_css "#phone"
      page.must_have_css "#age"
      page.must_have_css "#email"
      page.must_have_css "#password"
      page.must_have_css "#confirm_password"
      page.must_have_button "Create User"

      # num_email = Mail::TestMailer.deliveries.length
      #empty
      sign_up!("","")
      page.must_have_content "Can't be blank"
      page.current_path.must_equal "/users"
      # Mail::TestMailer.deliveries.length.must_equal num_email #no notification

      # num_email = Mail::TestMailer.deliveries.length
      #successfully create user
      sign_up!
      page.must_have_content "Hi, UserFirstname"
      page.must_have_content "Sign Out"
      page.current_path.must_equal "/reports"
      page.must_have_content "Welcome UserFirstname!"#flash message

      visit "/users/#{User.last.id}"
      find('#firstname').value.must_equal "UserFirstname"
      find('#lastname').value.must_equal "UserLastname"
      #user notification
      # Mail::TestMailer.deliveries.length.must_equal num_email+1
      # Mail::TestMailer.deliveries.last.to.must_equal ["test@email.com"]
      # Mail::TestMailer.deliveries.last.subject.must_equal "Welcome in TRB Blog"

      #sign_out and try to create user with the same email
      click_link "Sign Out"

      visit new_user_path
      sign_up!
      page.must_have_content "This email has been already used"
      page.current_path.must_equal "/users"
    end

    it "update" do
      log_in_as_user("my@email.com", "password")

      user = User.find_by(email: "my@email.com")

      visit user_path(user.id)

      page.must_have_content "Account details"
      page.must_have_button "Edit"
      page.must_have_button "Delete"
      page.must_have_button "Change Password"
      page.wont_have_button "Block"

      #update user
      click_button "Edit"
      page.must_have_css "#firstname"
      page.must_have_css "#lastname"
      page.must_have_selector ("#gender")
      page.must_have_css "#phone"
      page.must_have_css "#age"
      page.must_have_css "#email"
      page.current_path.must_equal "/users/#{user.id}/edit"
      page.must_have_button "Save"

      #set NewFirstname as firstname
      within("//form[@id='edit_user']") do
        fill_in 'Firstname',    with: "NewFirstname"
      end
      click_button "Save"

      page.must_have_content "New details saved" #flash message
      page.must_have_content "Hi, NewFirstname"
      page.current_path.must_equal "/users/#{user.id}"

      find('#firstname').value.must_equal "NewFirstname"

      #user2 trying to update user
      click_link "Sign Out"

      user2 = User::Create.({email: "test2@email.com", firstname: "User2", password: "password", confirm_password: "password"})["model"]
      submit!(user2.email, "password")

      page.must_have_content "Hi, User2"

      visit "/users/#{user.id}/edit"
      page.current_path.must_equal "/reports"
      page.must_have_content "You are not authorized mate!" #flash message
    end

    it "delete" do
      log_in_as_user("my@email.com", "password")
      user = User.find_by(email: "my@email.com")

      page.must_have_link "Hi, UserFirstname"

      click_link "Hi, UserFirstname"

      page.must_have_button "Edit"
      page.must_have_button "Delete"
      page.must_have_button "Change Password"

      # num_email = Mail::TestMailer.deliveries.length
      click_button "Delete"
      #user notification
      # Mail::TestMailer.deliveries.length.must_equal num_email+1
      # Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
      # Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - Your account has been deleted"

      page.must_have_content "User deleted"

      visit "/sessions/new"

      submit!("my@email.com", "password")

      page.must_have_content "User not found"
    end

    it "only admin can block user" do
      log_in_as_user("my@email.com", "password")
      click_link "Sign Out"

      log_in_as_admin
      click_link "Users"
      num_user = ::User.all.size - 1
      page.must_have_content "Users (#{num_user})"

      visit "/users/#{User.find_by(email: "my@email.com").id}"

      page.must_have_button "Block"
      # num_email = Mail::TestMailer.deliveries.length
      click_button "Block"

      page.must_have_content "UserFirstname has been blocked" #flash message
      page.current_path.must_equal users_path
      #user notification
      # Mail::TestMailer.deliveries.length.must_equal num_email+1
      # Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
      # Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - You have been blocked"

      visit "/users/#{User.find_by(email: "my@email.com").id}"
      page.must_have_button "Un-Block"

      click_link "Sign Out"

      visit "/sessions/new"
      submit!("my@email.com", "password")

      page.must_have_content "You have been blocked mate"

      log_in_as_admin

      #check that edit/change password/delete
      visit "/users/#{User.find_by(email: "admin@email.com").id}"
      page.wont_have_button "Block"
      page.wont_have_button "Un-Block"

      visit "/users/#{User.find_by(email: "my@email.com").id}"
      click_button "Un-Block"

      page.must_have_content "UserFirstname has been un-blocked" #flash message

      click_link "Sign Out"

      visit "/sessions/new"
      submit!("my@email.com", "password")
      page.must_have_content "Hi, UserFirstname"
      page.must_have_link "Sign Out"
    end
  end

  describe 'User/Tyrant Test' do
    it "change password - not authorized" do
      log_in_as_user("my@email.com", "password")
      user = User.find_by(email: "my@email.com")
      click_link "Sign Out"

      log_in_as_user("my2@email.com", "password")
      user2 = User.find_by(email: "my2@email.com")

      page.must_have_link "Hi, UserFirstname"

      click_link "Hi, UserFirstname"

      page.must_have_button "Change Password"

      click_button "Change Password"

      page.must_have_css "#email"
      page.must_have_css "#password"
      page.must_have_css "#new_password"
      page.must_have_css "#confirm_new_password"

      within("//form[@id='change_password']") do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: "password"
        fill_in 'New Password', with: "new_password"
        fill_in 'Confirm New Password', with: "new_password"
      end
      click_button "Change Password"

      page.must_have_content "You are not authorized mate!" #flash message
      page.wont_have_content "The new password has been saved" #flash message

      click_link "Sign Out"

      visit "/sessions/new"

      submit!("my@email.com", "new_password")
      page.must_have_content "Wrong Password"

      submit!("my@email.com", "password")
      page.must_have_link "Hi, UserFirstname"
    end

    it "change password" do
      log_in_as_user("my@email.com", "password")
      user = User.find_by(email: "my@email.com")

      page.must_have_link "Hi, UserFirstname"

      click_link "Hi, UserFirstname"

      page.must_have_button "Change Password"

      click_button "Change Password"

      page.must_have_css "#email"
      page.must_have_css "#password"
      page.must_have_css "#new_password"
      page.must_have_css "#confirm_new_password"

      # num_email = Mail::TestMailer.deliveries.length

      within("//form[@id='change_password']") do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: "password"
        fill_in 'New Password', with: "new_password"
        fill_in 'Confirm New Password', with: "new_password"
      end
      click_button "Change Password"

      page.must_have_content "The new password has been saved" #flash message
      #user notification
      # Mail::TestMailer.deliveries.length.must_equal num_email+1
      # Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
      # Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - Your password has been changed"

      click_link "Sign Out"

      visit "/sessions/new"

      submit!("my@email.com", "password")
      page.must_have_content "Wrong Password"

      submit!("my@email.com", "new_password")
      page.must_have_link "Hi, UserFirstname"
    end

    it "reset password" do
      log_in_as_user("my@email.com", "password")
      click_link "Sign Out"

      visit "/sessions/new"

      page.must_have_link "Forgot Password"

      click_link "Forgot Password"

      page.must_have_css "#email"
      page.must_have_button "Reset Password"

      #user doesn't exists
      within("//form[@id='get_email']") do
        fill_in 'Email', with: "wrong@email.com"
      end
      click_button "Reset Password"

      page.must_have_content "User not found"

      within("//form[@id='get_email']") do
        fill_in 'Email', with: "my@email.com"
      end
      click_button "Reset Password"

      page.must_have_content "You will receive an email with some instructions!" #flash message

      page.current_path.must_equal "/sessions/new"

      visit "/users/confirm_new_password?safe_url=safe_url&email=my@email.com"

      page.must_have_button "Save"
      page.must_have_css "#email"
      page.must_have_css "#new_password"
      page.must_have_css "#confirm_new_password"

      click_button "Save"

      page.must_have_content "must be filled"

      within("//form[@id='confirm_new_password']") do
        fill_in 'New Password', with: "new_password"
        fill_in 'Confirm New Password', with: "new_password"
      end
      click_button "Save"

      page.current_path.must_equal "/reports"
      page.must_have_link "Hi, UserFirstname"

      visit "/users/confirm_new_password?safe_url=safe_url&email=my@email.com"

      click_button "Save"

      page.must_have_content "Link expired"
    end
  end
end

require 'test_helper'

class UsersIntegrationTest < Trailblazer::Test::Integration

  describe 'User CRUD test' do
    # it "create user" do
    #   visit 'users/new'

    #   page.must_have_css "#firstname"
    #   page.must_have_css "#lastname"
    #   page.must_have_selector ("#gender")
    #   page.must_have_css "#phone"
    #   page.must_have_css "#age"
    #   page.must_have_css "#email"
    #   page.must_have_css "#password"
    #   page.must_have_css "#confirm_password"
    #   page.must_have_button "Create User"

    #   # num_email = Mail::TestMailer.deliveries.length
    #   #empty
    #   sign_up!("","")
    #   page.must_have_content "Can't be blank"
    #   page.current_path.must_equal "/users"
    #   # Mail::TestMailer.deliveries.length.must_equal num_email #no notification

    #   # num_email = Mail::TestMailer.deliveries.length
    #   #successfully create user
    #   sign_up!
    #   page.must_have_content "Hi, UserFirstname"
    #   page.must_have_content "Sign Out"
    #   page.current_path.must_equal "/reports"
    #   page.must_have_content "Welcome UserFirstname!"#flash message
    #   #user notification
    #   # Mail::TestMailer.deliveries.length.must_equal num_email+1
    #   # Mail::TestMailer.deliveries.last.to.must_equal ["test@email.com"]
    #   # Mail::TestMailer.deliveries.last.subject.must_equal "Welcome in TRB Blog"

    #   #sign_out and try to create user with the same email
    #   click_link "Sign Out"

    #   visit new_user_path
    #   sign_up!
    #   page.must_have_content "This email has been already used"
    #   page.current_path.must_equal "/users"
    # end

    # it "update" do
    #   log_in_as_user("my@email.com", "password")

    #   user = User.find_by(email: "my@email.com")

    #   visit user_path(user.id)

    #   page.must_have_content "Account details"
    #   page.must_have_button "Edit"
    #   page.must_have_button "Delete"
    #   page.must_have_button "Change Password"
    #   page.wont_have_button "Block"

    #   #update user
    #   click_button "Edit"
    #   page.must_have_css "#firstname"
    #   page.must_have_css "#lastname"
    #   page.must_have_selector ("#gender")
    #   page.must_have_css "#phone"
    #   page.must_have_css "#age"
    #   page.must_have_css "#email"
    #   page.current_path.must_equal "/users/#{user.id}/edit"
    #   page.must_have_button "Save"

    #   #set NewFirstname as firstname
    #   within("//form[@id='edit_user']") do
    #     fill_in 'Firstname',    with: "NewFirstname"
    #   end
    #   click_button "Save"


    #   page.must_have_content "New details saved" #flash message
    #   page.must_have_content "Hi, NewFirstname"
    #   page.current_path.must_equal "/users/#{user.id}"

    #   #user2 trying to update user
    #   click_link "Sign Out"

    #   user2 = User.find_by(email: "test2@email.com")
    #   submit!(user2.email, "password")

    #   page.must_have_content "Hi, User2"

    #   visit "/users/#{user.id}/edit"
    #   page.current_path.must_equal "/reports"
    #   page.must_have_content "You are not authorized mate!" #flash message
    # end

    # it "delete" do
    #   log_in_as_user("my@email.com", "password")
    #   user = User.find_by(email: "my@email.com")

    #   page.must_have_link "Hi, UserFirstname"

    #   click_link "Hi, UserFirstname"

    #   page.must_have_button "Edit"
    #   page.must_have_button "Delete"
    #   page.must_have_button "Change Password"

    #   # num_email = Mail::TestMailer.deliveries.length
    #   click_button "Delete"
    #   #user notification
    #   # Mail::TestMailer.deliveries.length.must_equal num_email+1
    #   # Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
    #   # Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - Your account has been deleted"

    #   page.must_have_content "User deleted"

    #   visit "/sessions/new"

    #   submit!("my@email.com", "password")

    #   page.must_have_content "User not found"
    # end

    # it "only admin can block user" do
    #   log_in_as_user("my@email.com", "password")
    #   click_link "Sign Out"

    #   log_in_as_admin
    #   click_link "Users"
    #   num_user = ::User.all.size - 1
    #   page.must_have_content "Users (#{num_user})"

    #   visit "/users/#{User.find_by(email: "my@email.com").id}"

    #   page.must_have_button "Block"
    #   # num_email = Mail::TestMailer.deliveries.length
    #   click_button "Block"

    #   page.must_have_content "UserFirstname has been blocked" #flash message
    #   page.current_path.must_equal users_path
    #   #user notification
    #   # Mail::TestMailer.deliveries.length.must_equal num_email+1
    #   # Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
    #   # Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - You have been blocked"

    #   visit "/users/#{User.find_by(email: "my@email.com").id}"
    #   page.must_have_button "Un-Block"

    #   click_link "Sign Out"

    #   visit "/sessions/new"
    #   submit!("my@email.com", "password")

    #   page.must_have_content "You have been blocked mate"

    #   log_in_as_admin

    #   #check that edit/change password/delete
    #   visit "/users/#{User.find_by(email: "admin@email.com").id}"
    #   page.wont_have_button "Block"
    #   page.wont_have_button "Un-Block"

    #   visit "/users/#{User.find_by(email: "my@email.com").id}"
    #   click_button "Un-Block"

    #   page.must_have_content "UserFirstname has been un-blocked" #flash message

    #   click_link "Sign Out"

    #   visit "/sessions/new"
    #   submit!("my@email.com", "password")
    #   page.must_have_content "Hi, UserFirstname"
    #   page.must_have_link "Sign Out"
    # end
  end

  describe 'User/Tyrant Test' do
    # it "change password - not authorized" do
    #   log_in_as_user("my@email.com", "password")
    #   user = User.find_by(email: "my@email.com")
    #   click_link "Sign Out"

    #   log_in_as_user("my2@email.com", "password")
    #   user2 = User.find_by(email: "my2@email.com")

    #   page.must_have_link "Hi, UserFirstname"

    #   click_link "Hi, UserFirstname"

    #   page.must_have_button "Change Password"

    #   click_button "Change Password"

    #   page.must_have_css "#email"
    #   page.must_have_css "#password"
    #   page.must_have_css "#new_password"
    #   page.must_have_css "#confirm_new_password"

    #   within("//form[@id='change_password']") do
    #     fill_in 'Email', with: user.email
    #     fill_in 'Password', with: "password"
    #     fill_in 'New Password', with: "new_password"
    #     fill_in 'Confirm New Password', with: "new_password"
    #   end
    #   click_button "Change Password"

    #   page.must_have_content "You are not authorized mate!" #flash message
    #   page.wont_have_content "The new password has been saved" #flash message

    #   click_link "Sign Out"

    #   visit "/sessions/new"

    #   submit!("my@email.com", "new_password")
    #   page.must_have_content "Wrong Password"

    #   submit!("my@email.com", "password")
    #   page.must_have_link "Hi, UserFirstname"
    # end

    # it "change password" do
    #   log_in_as_user("my@email.com", "password")
    #   user = User.find_by(email: "my@email.com")

    #   page.must_have_link "Hi, UserFirstname"

    #   click_link "Hi, UserFirstname"

    #   page.must_have_button "Change Password"

    #   click_button "Change Password"

    #   page.must_have_css "#email"
    #   page.must_have_css "#password"
    #   page.must_have_css "#new_password"
    #   page.must_have_css "#confirm_new_password"

    #   # num_email = Mail::TestMailer.deliveries.length

    #   within("//form[@id='change_password']") do
    #     fill_in 'Email', with: user.email
    #     fill_in 'Password', with: "password"
    #     fill_in 'New Password', with: "new_password"
    #     fill_in 'Confirm New Password', with: "new_password"
    #   end
    #   click_button "Change Password"

    #   page.must_have_content "The new password has been saved" #flash message
    #   #user notification
    #   # Mail::TestMailer.deliveries.length.must_equal num_email+1
    #   # Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
    #   # Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - Your password has been changed"

    #   click_link "Sign Out"

    #   visit "/sessions/new"

    #   submit!("my@email.com", "password")
    #   page.must_have_content "Wrong Password"

    #   submit!("my@email.com", "new_password")
    #   page.must_have_link "Hi, UserFirstname"
    # end

    # it "reset password" do
    #   log_in_as_user("my@email.com", "password")
    #   click_link "Sign Out"

    #   visit "/sessions/new"

    #   page.must_have_link "Forgot Password"

    #   click_link "Forgot Password"

    #   page.must_have_css "#email"
    #   page.must_have_button "Reset Password"

    #   #user doesn't exists
    #   within("//form[@id='get_email']") do
    #     fill_in 'Email', with: "wrong@email.com"
    #   end
    #   click_button "Reset Password"

    #   page.must_have_content "User not found"

    #   within("//form[@id='get_email']") do
    #     fill_in 'Email', with: "my@email.com"
    #   end
    #   click_button "Reset Password"

    #   page.must_have_content "You will receive an email with some instructions!" #flash message

    #   page.current_path.must_equal "/sessions/new"

    #   visit "/users/confirm_new_password?safe_url=safe_url&email=my@email.com"

    #   page.must_have_button "Save"
    #   page.must_have_css "#email"
    #   page.must_have_css "#new_password"
    #   page.must_have_css "#confirm_new_password"

    #   click_button "Save"

    #   page.must_have_content "must be filled"

    #   within("//form[@id='confirm_new_password']") do
    #     fill_in 'New Password', with: "new_password"
    #     fill_in 'Confirm New Password', with: "new_password"
    #   end
    #   click_button "Save"

    #   page.current_path.must_equal "/reports"
    #   page.must_have_link "Hi, UserFirstname"

    #   visit "/users/confirm_new_password?safe_url=safe_url&email=my@email.com"

    #   click_button "Save"

    #   page.must_have_content "Link expired"
    # end
  end

  describe 'User report settings/template' do

    it "edit settings" do
      log_in_as_user("my@email.com", "password")

      page.must_have_content "Hi, UserFirstname"

      user = User.find_by(email: 'my@email.com')

      visit "/users/#{user.id}/settings"

      page.must_have_content "Report Settings"
      page.must_have_button "Edit"
      page.must_have_content "Subject Settings"
      page.must_have_content "Parameters list"
      page.must_have_content "Ergometer Parameters"
      page.must_have_content "Training Zones Levels"
      page.must_have_content  "cm"
      page.must_have_content  "kg"
      page.must_have_content  "Power"
      page.must_have_content  "Watt"
      page.must_have_content  "Revolution"
      page.must_have_content  "RPM"
      page.must_have_content  "35"
      page.must_have_content  "50"
      page.must_have_content  "51"
      page.must_have_content  "75"
      page.must_have_content  "76"
      page.must_have_content  "90"
      page.must_have_content  "91"
      page.must_have_content  "100"

      first('.button_to').click_button("Edit")
      page.must_have_content "Report Settings"
      page.must_have_css '#um_height'
      page.must_have_css '#um_weight'
      page.must_have_css '#params_list'
      page.must_have_css '#load_1'
      page.must_have_css '#load_1_um'
      page.must_have_css '#load_2'
      page.must_have_css '#load_2_um'
      page.must_have_css '#fat_burning_1'
      page.must_have_css '#level2'
      page.must_have_css '#level3'
      page.must_have_css '#level4'
      page.must_have_css '#level5'
      page.must_have_css '#level6'
      page.must_have_css '#level7'
      page.must_have_css '#vo2max_2'
      page.must_have_button "Save"
      page.must_have_button "Default Settings"

       within("//form[@id='report_settings']") do
        select('in', :from => 'um_height')
        select('lbs', :from => 'um_weight')
        fill_in 'params_list', with: "Param1,Param2,Param3"
        fill_in 'load_1', with: "load_1"
        fill_in 'load_1_um', with: "load_1_um"
        fill_in 'load_2', with: "load_2"
        fill_in 'load_2_um', with: "load_2_um"
        select('49', :from => 'level2')
        select('65', :from => 'level3')
        select('74', :from => 'level4')
        select('80', :from => 'level5')
        select('85', :from => 'level6')
        select('95', :from => 'level7')
      end
      click_button "Save"

      page.current_path.must_equal "/users/#{user.id}/settings"

      page.must_have_content  "in"
      page.must_have_content  "lbs"
      page.must_have_content  "Param1 - Param2 - Param3"
      page.must_have_content  "load_1"
      page.must_have_content  "load_1_um"
      page.must_have_content  "load_2"
      page.must_have_content  "load_2_um"
      page.must_have_content  "35"
      page.must_have_content  "49"
      page.must_have_content  "65"
      page.must_have_content  "74"
      page.must_have_content  "80"
      page.must_have_content  "85"
      page.must_have_content  "95"
      page.must_have_content  "100"

      # test validations
      first('.button_to').click_button("Edit")

      within("//form[@id='report_settings']") do
        fill_in 'params_list', with: ""
        select('2', :from => 'level2')
        select('2', :from => 'level4')
      end
      click_button "Save"

      page.must_have_content "Can't be blank"
      page.must_have_content "This must be greater than 35"
      page.must_have_content "This range was wrong or over the previous one"
    end

    it "edit template" do
      log_in_as_user("my@email.com", "password")
      page.must_have_content "Hi, UserFirstname"

      user = User.find_by(email: 'my@email.com')

      subject = Subject::Create.({
          user_id: user.id,
          firstname: "Ema",
          lastname: "Maglio",
          gender: "Male",
          dob: "01/01/1980",
          height: "180",
          weight: "80",
          phone: "912873",
          email: "ema@email.com"
        }, "current_user" => user)["model"]

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

      visit "/users/#{user.id}/settings"

      within('.default_template') do
        page.must_have_content "Default"
        page.must_have_content "VO2 and VCO2 on time"
        page.must_have_content "HR, Power and Ve on time"
        page.must_have_content "VO2max Test Summary"
        page.must_have_content "Training Zones"
        page.wont_have_button "Edit"
      end

      within('.custom_template') do
        page.must_have_content "Custom"
        page.must_have_content "VO2 and VCO2 on time"
        page.must_have_content "HR, Power and Ve on time"
        page.must_have_content "VO2max Test Summary"
        page.must_have_content "Training Zones"

      end

      page.all('.button_to')[1].click_button("Edit")
      page.current_path.must_equal "/users/#{user.id}/get_report_template"

      # first element not having the UP button
      within('#forms_0') do
        page.must_have_css '#type'
        page.must_have_button 'Add it'
        page.must_have_button 'Delete'
        page.must_have_button 'Edit'
        page.must_have_css '#move_down'
        page.wont_have_css '#move_up'
      end

      # last element not having the DOWN button
      # training zones element no Edit button as well
      within('#forms_3') do
        page.must_have_css '#type'
        page.must_have_button 'Add it'
        page.must_have_button 'Delete'
        page.wont_have_button 'Edit'
        page.wont_have_css '#move_down'
        page.must_have_css '#move_up'
      end
    end
  end
end

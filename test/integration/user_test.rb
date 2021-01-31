# frozen_string_literal: true

require 'test_helper'

class UserIntegrationTest < Trailblazer::Test::Integration
  describe 'User CRUD test' do
    it 'create user' do
      visit 'users/new'

      _(page).must_have_css '#firstname'
      _(page).must_have_css '#lastname'
      _(page).must_have_selector('#gender')
      _(page).must_have_css '#phone'
      _(page).must_have_css '#age'
      _(page).must_have_css '#email'
      _(page).must_have_css '#password'
      _(page).must_have_css '#confirm_password'
      _(page).must_have_button 'Create User'

      # num_email = Mail::TestMailer.deliveries.length
      # empty
      sign_up!('', '')
      _(page).must_have_content "Can't be blank"
      _(page.current_path).must_equal '/users'
      # Mail::TestMailer.deliveries.length.must_equal num_email #no notification

      # num_email = Mail::TestMailer.deliveries.length
      # successfully create user
      sign_up!
      _(page).must_have_content 'Hi, UserFirstname'
      _(page).must_have_content 'Sign Out'
      _(page.current_path).must_equal '/reports'
      _(page).must_have_content 'Welcome UserFirstname!' # flash message

      visit "/users/#{User.last.id}"
      _(find('#firstname').value).must_equal 'UserFirstname'
      _(find('#lastname').value).must_equal 'UserLastname'
      # user notification
      # Mail::TestMailer.deliveries.length.must_equal num_email+1
      # Mail::TestMailer.deliveries.last.to.must_equal ["test@email.com"]
      # Mail::TestMailer.deliveries.last.subject.must_equal "Welcome in TRB Blog"

      # sign_out and try to create user with the same email
      click_link 'Sign Out'

      visit new_user_path
      sign_up!
      _(page).must_have_content 'This email has been already used'
      _(page.current_path).must_equal '/users'
    end

    it 'update' do
      log_in_as_user('my@email.com', 'password')

      user = User.find_by(email: 'my@email.com')

      visit user_path(user.id)

      _(page).must_have_content 'Account details'
      _(page).must_have_button 'Edit'
      _(page).must_have_button 'Delete'
      _(page).must_have_button 'Change Password'
      _(page).wont_have_button 'Block'

      # update user
      click_button 'Edit'
      _(page).must_have_css '#firstname'
      _(page).must_have_css '#lastname'
      _(page).must_have_selector '#gender'
      _(page).must_have_css '#phone'
      _(page).must_have_css '#age'
      _(page).must_have_css '#email'
      _(page.current_path).must_equal "/users/#{user.id}/edit"
      _(page).must_have_button 'Save'

      # set NewFirstname as firstname
      within("//form[@id='edit_user']") do
        fill_in 'Firstname', with: 'NewFirstname'
      end
      click_button 'Save'

      _(page).must_have_content 'New details saved' # flash message
      _(page).must_have_content 'Hi, NewFirstname'
      _(page.current_path).must_equal "/users/#{user.id}"

      _(find('#firstname').value).must_equal 'NewFirstname'

      # user2 trying to update user
      click_link 'Sign Out'

      user2 = User::Create.(
        email: 'test2@email.com', firstname: 'User2', password: 'password', confirm_password: 'password'
      )['model']
      submit!(user2.email, 'password')

      _(page).must_have_content 'Hi, User2'

      visit "/users/#{user.id}/edit"
      _(page.current_path).must_equal '/reports'
      _(page).must_have_content 'You are not authorized mate!' # flash message
    end

    it 'delete' do
      log_in_as_user('my@email.com', 'password')

      _(page).must_have_link 'Hi, UserFirstname'

      click_link 'Hi, UserFirstname'

      _(page).must_have_button 'Edit'
      _(page).must_have_button 'Delete'
      _(page).must_have_button 'Change Password'

      # num_email = Mail::TestMailer.deliveries.length
      click_button 'Delete'
      # user notification
      # Mail::TestMailer.deliveries.length.must_equal num_email+1
      # Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
      # Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - Your account has been deleted"

      _(page).must_have_content 'User deleted'

      visit '/sessions/new'

      submit!('my@email.com', 'password')

      _(page).must_have_content 'User not found'
    end

    it 'only admin can block user' do
      log_in_as_user('my@email.com', 'password')
      click_link 'Sign Out'

      user_id = User.find_by(email: 'my@email.com').id

      log_in_as_admin
      click_link 'Users'
      num_user = ::User.all.size - 1
      _(page).must_have_content "Users (#{num_user})"

      visit "/users/#{user_id}"

      _(page).must_have_button 'Block'
      # num_email = Mail::TestMailer.deliveries.length
      click_button 'Block'

      _(page).must_have_content 'UserFirstname has been blocked' # flash message
      _(page.current_path).must_equal users_path
      # user notification
      # Mail::TestMailer.deliveries.length.must_equal num_email+1
      # Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
      # Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - You have been blocked"

      visit "/users/#{user_id}"
      _(page).must_have_button 'Un-Block'

      click_link 'Sign Out'

      visit '/sessions/new'
      submit!('my@email.com', 'password')

      _(page).must_have_content 'You have been blocked mate'

      log_in_as_admin

      # check that edit/change password/delete
      visit "/users/#{User.find_by(email: 'admin@email.com').id}"
      _(page).wont_have_button 'Block'
      _(page).wont_have_button 'Un-Block'

      visit "/users/#{user_id}"
      click_button 'Un-Block'

      _(page).must_have_content 'UserFirstname has been un-blocked' # flash message

      click_link 'Sign Out'

      visit '/sessions/new'
      submit!('my@email.com', 'password')
      _(page).must_have_content 'Hi, UserFirstname'
      _(page).must_have_link 'Sign Out'
    end
  end

  describe 'User/Tyrant Test' do
    it 'change password - not authorized' do
      log_in_as_user('my@email.com', 'password')
      user = User.find_by(email: 'my@email.com')
      click_link 'Sign Out'

      log_in_as_user('my2@email.com', 'password')

      _(page).must_have_link 'Hi, UserFirstname'

      click_link 'Hi, UserFirstname'

      _(page).must_have_button 'Change Password'

      click_button 'Change Password'

      _(page).must_have_css '#email'
      _(page).must_have_css '#password'
      _(page).must_have_css '#new_password'
      _(page).must_have_css '#confirm_new_password'

      within("//form[@id='change_password']") do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password'
        fill_in 'New Password', with: 'new_password'
        fill_in 'Confirm New Password', with: 'new_password'
      end
      click_button 'Change Password'

      _(page).must_have_content 'You are not authorized mate!' # flash message
      _(page).wont_have_content 'The new password has been saved' # flash message

      click_link 'Sign Out'

      visit '/sessions/new'

      submit!('my@email.com', 'new_password')
      _(page).must_have_content 'Wrong Password'

      submit!('my@email.com', 'password')
      _(page).must_have_link 'Hi, UserFirstname'
    end

    it 'change password' do
      log_in_as_user('my@email.com', 'password')
      user = User.find_by(email: 'my@email.com')

      _(page).must_have_link 'Hi, UserFirstname'

      click_link 'Hi, UserFirstname'

      _(page).must_have_button 'Change Password'

      click_button 'Change Password'

      _(page).must_have_css '#email'
      _(page).must_have_css '#password'
      _(page).must_have_css '#new_password'
      _(page).must_have_css '#confirm_new_password'

      # num_email = Mail::TestMailer.deliveries.length

      within("//form[@id='change_password']") do
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'password'
        fill_in 'New Password', with: 'new_password'
        fill_in 'Confirm New Password', with: 'new_password'
      end
      click_button 'Change Password'

      _(page).must_have_content 'The new password has been saved' # flash message
      # user notification
      # Mail::TestMailer.deliveries.length.must_equal num_email+1
      # Mail::TestMailer.deliveries.last.to.must_equal ["my@email.com"]
      # Mail::TestMailer.deliveries.last.subject.must_equal "TRB Blog Notification - Your password has been changed"

      click_link 'Sign Out'

      visit '/sessions/new'

      submit!('my@email.com', 'password')
      _(page).must_have_content 'Wrong Password'

      submit!('my@email.com', 'new_password')
      _(page).must_have_link 'Hi, UserFirstname'
    end

    it 'reset password' do
      log_in_as_user('my@email.com', 'password')
      click_link 'Sign Out'

      visit '/sessions/new'

      _(page).must_have_link 'Forgot Password'

      click_link 'Forgot Password'

      _(page).must_have_css '#email'
      _(page).must_have_button 'Reset Password'

      # user doesn't exists
      within("//form[@id='get_email']") do
        fill_in 'Email', with: 'wrong@email.com'
      end
      click_button 'Reset Password'

      _(page).must_have_content 'User not found'

      within("//form[@id='get_email']") do
        fill_in 'Email', with: 'my@email.com'
      end
      click_button 'Reset Password'

      _(page).must_have_content 'You will receive an email with some instructions!' # flash message

      _(page.current_path).must_equal '/sessions/new'

      log_in_as_user('my@email.com', 'NewPassword')

      _(page.current_path).must_equal '/reports'
      _(page).must_have_link 'Hi, UserFirstname'
    end
  end
end

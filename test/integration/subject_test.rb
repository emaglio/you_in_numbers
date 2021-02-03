# frozen_string_literal: true

require 'test_helper'

class SubjectIntegrationTest < Trailblazer::Test::Integration
  describe 'Subject CRUD' do
    it 'Create subject from scratch' do
      log_in_as_user

      click_link 'New Subject'
      _(page.current_path).must_equal '/subjects/new'

      _(page).must_have_content 'New Subject'
      _(page).must_have_css '#firstname'
      _(page).must_have_css '#lastname'
      _(page).must_have_css '#gender'
      _(page).must_have_css '#dob'
      _(page).must_have_css '#height'
      _(page).must_have_css '#weight'
      _(page).must_have_css '#phone'
      _(page).must_have_css '#email'
      _(page).must_have_button 'Create Subject'

      # test errors
      click_button 'Create Subject'
      _(page).must_have_content "Can't be blank"

      # create subject successfully
      new_subject!

      _(page).must_have_content 'Subject created'
      _(page.current_path).must_equal '/subjects'

      visit "/subjects/#{Subject.last.id}"

      _(find('#firstname').value).must_equal 'SubjectFirstname'
      _(find('#lastname').value).must_equal 'SubjectLastname'
      _(find('#gender').value).must_equal 'Male'
      _(find('#dob').value).must_equal '01/Jan/1980'
      _(find('#height').value).must_equal '180'
      _(find('#weight').value).must_equal '80'
      _(find('#phone').value).must_equal '0128471'
      _(find('#email').value).must_equal 'subject@email.com'
    end

    it "Only subject's owner can edit it" do
      log_in_as_user

      new_subject!

      click_link 'Sign Out'

      user2 = User::Operation::Create.(
        email: 'test2@email.com',
        firstname: 'User2',
        password: 'password',
        confirm_password: 'password'
      )['model']
      submit!(user2.email, 'password')

      visit "/subjects/#{Subject.last.id}"
      _(page).must_have_content 'You are not authorized mate!'
      _(page.current_path).must_equal '/reports'

      log_in_as_user
      visit "/subjects/#{Subject.last.id}"
      click_button 'Edit'

      _(page).must_have_content 'New Subject'
      _(page).must_have_css '#firstname'
      _(page).must_have_css '#lastname'
      _(page).must_have_css '#gender'
      _(page).must_have_css '#dob'
      _(page).must_have_css '#height'
      _(page).must_have_css '#weight'
      _(page).must_have_css '#phone'
      _(page).must_have_css '#email'
      _(page).must_have_button 'Save Changes'

      within("//form[@id='edit_subject']") do
        fill_in 'firstname', with: 'NewSubjectFirstname'
      end
      click_button 'Save Changes'

      _(page.current_path).must_equal "/subjects/#{Subject.last.id}"

      _(find('#firstname').value).must_equal 'NewSubjectFirstname'
    end

    it 'Delete Subject' do
      log_in_as_user

      new_subject!

      subject_num = Subject.all.size

      visit "/subjects/#{Subject.last.id}"

      click_button 'Delete'

      _(page).must_have_content 'Subject deleted'
      _(Subject.all.size).must_equal subject_num - 1
    end
  end
end

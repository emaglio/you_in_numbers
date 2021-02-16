# frozen_string_literal: true

require 'test_helper'

class CompanyIntegationTest < Trailblazer::Test::Integration
  describe 'Company CRUD' do
    it 'Company from scratch' do
      log_in_as_user
      user = User.find_by(email: 'my@email.com')
      visit "/users/#{user.id}"

      _(page).must_have_content 'Company details'
      _(page).must_have_content 'Your company details has not been set!'
      _(page).must_have_button 'Update details'

      click_button 'Update details'

      _(page.current_path).must_equal '/companies/new'

      _(page).must_have_css '#name'
      _(page).must_have_css '#address_1'
      _(page).must_have_css '#address_2'
      _(page).must_have_css '#city'
      _(page).must_have_css '#postcode'
      _(page).must_have_css '#country'
      _(page).must_have_css '#email'
      _(page).must_have_css '#phone'
      _(page).must_have_css '#website'
      _(page).must_have_selector('input[type=file][name=logo]')
      _(page).must_have_button 'Create Company'

      within("//form[@id='new_company']") do
        fill_in 'Name',    with: 'My Company'
      end
      click_button 'Create Company'

      _(find('#name').value).must_equal 'My Company'

      _(page).wont_have_content 'Your company details has not been set!'
      _(page).wont_have_button 'Update details'

      _(page).must_have_content 'Company details updated!'
      _(page).must_have_content 'No logo'
      _(page).must_have_button 'Edit'
      _(page).must_have_button 'Delete'
      _(page).must_have_button 'Upload Logo'
    end

    it 'Upload/Delete logo' do
      log_in_as_user
      user = User.find_by(email: 'my@email.com')
      visit "/users/#{user.id}"

      click_button 'Update details'
      within("//form[@id='new_company']") do
        fill_in 'Name',    with: 'My Company'
      end
      click_button 'Create Company'

      _(page).must_have_content 'No logo'
      click_button 'Upload Logo'

      _(page.current_path).must_equal "/companies/#{Company.last.id}/edit"

      _(page).must_have_css '#name'
      _(page).must_have_css '#address_1'
      _(page).must_have_css '#address_2'
      _(page).must_have_css '#city'
      _(page).must_have_css '#postcode'
      _(page).must_have_css '#country'
      _(page).must_have_css '#email'
      _(page).must_have_css '#phone'
      _(page).must_have_css '#website'
      _(page).must_have_css '#website'
      _(page).must_have_selector('input[type=file][name=logo]')
      _(page).must_have_button 'Save Changes'

      within("//form[@id='edit_company']") do
        attach_file('logo', Rails.root.join('test/images/logo.jpeg'))
      end
      click_button 'Save Changes'

      _(page).must_have_content 'Company details updated!'
      _(page).wont_have_content 'No logo'
      _(page).must_have_button 'Remove Logo'

      _(find('.logo')['src']).must_equal '/images/thumb-logo.jpeg'

      click_button 'Remove Logo'
      _(page).must_have_content 'Company Logo deleted!'
      _(page).must_have_content 'No logo'
      _(page).must_have_button 'Upload Logo'
    end

    it "Only company's owner can edit it" do
      log_in_as_user
      user = User.find_by(email: 'my@email.com')
      visit "/users/#{user.id}"

      click_button 'Update details'
      within("//form[@id='new_company']") do
        fill_in 'Name', with: 'My Company'
      end
      click_button 'Create Company'

      click_link 'Sign Out'

      user2 = User::Operation::Create.(
        params: { email: 'test2@email.com', firstname: 'User2', password: 'password', confirm_password: 'password' }
      )[:model]
      submit!(user2.email, 'password')

      visit "/companies/#{Company.last.id}/edit"
      _(page).must_have_content 'You are not authorized mate!'
      _(page.current_path).must_equal '/reports'
    end

    it 'Delete Company' do
      log_in_as_user
      user = User.find_by(email: 'my@email.com')
      visit "/users/#{user.id}"

      click_button 'Update details'
      within("//form[@id='new_company']") do
        fill_in 'Name', with: 'My Company'
      end
      click_button 'Create Company'

      visit "/users/#{user.id}"

      find('#delete_company').click

      _(page).must_have_content 'Company deleted!'
      _(page).must_have_button 'Update details'
    end
  end
end

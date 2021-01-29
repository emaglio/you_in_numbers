# frozen_string_literal: true

require 'test_helper'

class CompanyIntegationTest < Trailblazer::Test::Integration
  describe 'Company CRUD' do
    it 'Company from scratch' do
      log_in_as_user
      user = User.find_by(email: 'my@email.com')
      visit "/users/#{user.id}"

      page.must_have_content 'Company details'
      page.must_have_content 'Your company details has not been set!'
      page.must_have_button 'Update details'

      click_button 'Update details'

      page.current_path.must_equal '/companies/new'

      page.must_have_css '#name'
      page.must_have_css '#address_1'
      page.must_have_css '#address_2'
      page.must_have_css '#city'
      page.must_have_css '#postcode'
      page.must_have_css '#country'
      page.must_have_css '#email'
      page.must_have_css '#phone'
      page.must_have_css '#website'
      page.must_have_selector('input[type=file][name=logo]')
      page.must_have_button 'Create Company'

      within("//form[@id='new_company']") do
        fill_in 'Name',    with: 'My Company'
      end
      click_button 'Create Company'

      find('#name').value.must_equal 'My Company'

      page.wont_have_content 'Your company details has not been set!'
      page.wont_have_button 'Update details'

      page.must_have_content 'Company details updated!'
      page.must_have_content 'No logo'
      page.must_have_button 'Edit'
      page.must_have_button 'Delete'
      page.must_have_button 'Upload Logo'

      Company::Delete.({ id: Company.last }, 'current_user' => user)
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

      page.must_have_content 'No logo'
      click_button 'Upload Logo'

      page.current_path.must_equal "/companies/#{Company.last.id}/edit"

      page.must_have_css '#name'
      page.must_have_css '#address_1'
      page.must_have_css '#address_2'
      page.must_have_css '#city'
      page.must_have_css '#postcode'
      page.must_have_css '#country'
      page.must_have_css '#email'
      page.must_have_css '#phone'
      page.must_have_css '#website'
      page.must_have_css '#website'
      page.must_have_selector('input[type=file][name=logo]')
      page.must_have_button 'Save Changes'

      within("//form[@id='edit_company']") do
        attach_file('logo', Rails.root.join('test/images/logo.jpeg'))
      end
      click_button 'Save Changes'

      page.must_have_content 'Company details updated!'
      page.wont_have_content 'No logo'
      page.must_have_button 'Remove Logo'

      find('.logo')['src'].must_equal '/images/thumb-logo.jpeg'

      click_button 'Remove Logo'
      page.must_have_content 'Company Logo deleted!'
      page.must_have_content 'No logo'
      page.must_have_button 'Upload Logo'

      Company::Delete.({ id: Company.last }, 'current_user' => user)
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

      user2 = User::Create.(
        email: 'test2@email.com', firstname: 'User2', password: 'password', confirm_password: 'password'
      )['model']
      submit!(user2.email, 'password')

      visit "/companies/#{Company.last.id}/edit"
      page.must_have_content 'You are not authorized mate!'
      page.current_path.must_equal '/reports'
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

      page.must_have_content 'Company deleted!'
      page.must_have_button 'Update details'
    end
  end
end

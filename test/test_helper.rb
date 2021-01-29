# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara-screenshot/minitest'
require 'minitest/autorun'
require 'trailblazer/rails/test/integration'
require 'tyrant'
require 'database_cleaner'
require 'trailblazer/test'
require "trailblazer/test/deprecation/operation/assertions"

DatabaseCleaner.strategy = :transaction

Minitest::Spec.class_eval do
  include Trailblazer::Test::Assertions
  include Trailblazer::Test::Operation::Helper
  include Trailblazer::Test::Operation::Assertions
  include Trailblazer::Test::Deprecation::Operation::Assertions

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  def admin_for
    User.find_by(email: 'admin@email.com') ||
      User::Create.(
        email: 'admin@email.com',
        password: 'password',
        confirm_password: 'password',
        firstname: 'Admin',
        admin: true
      )['model']
  end

  def get_data_sheet(file)
    rows = 0
    sheet_name = nil
    file.each_with_pagename do |name, sheet|
      if sheet.last_row > rows
        rows = sheet.last_row
        sheet_name = name
      end
    end

    sheet_name
  end
end

Cell::TestCase.class_eval do
  include Capybara::DSL
  include Capybara::Assertions
end

Trailblazer::Test::Integration.class_eval do
  include Capybara::Screenshot::MiniTestPlugin

  def admin_for
    User.find_by(email: 'admin@email.com') ||
      User::Create.(
        email: 'admin@email.com',
        password: 'password',
        confirm_password: 'password',
        firstname: 'Admin',
        admin: true
      )['model']
  end

  # puts page.body
  def submit!(email, password)
    within("//form[@id='new_session']") do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end
    click_button 'Sign In'
  end

  def sign_up!(email = 'test@email.com', password = 'password')
    within("//form[@id='new_user']") do
      fill_in 'Firstname', with: 'UserFirstname'
      fill_in 'Lastname', with: 'UserLastname'
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
      fill_in 'Confirm Password', with: password
      select('Male', from: 'gender')
      fill_in 'Age', with: '31'
      fill_in 'Phone', with: '32343211'
    end
    click_button 'Create User'
  end

  def log_in_as_admin
    admin_for

    visit '/sessions/new'
    submit!('admin@email.com', 'password')
  end

  def log_in_as_user(email = 'my@email.com', password = 'password')
    if User.find_by(email: email).nil?
      email = User::Create.(
        email: email, password: password, confirm_password: password, firstname: 'UserFirstname'
      )['model'].email
    end

    visit '/sessions/new'
    submit!(email, password)
  end

  def new_subject!(
    firstname = 'SubjectFirstname', lastname = 'SubjectLastname', gender = 'Male', dob = '01/01/1980',
    height = '180', weight = '80', phone = '0128471', email = 'subject@email.com'
  )
    visit '/subjects/new'

    within("//form[@id='new_subject']") do
      fill_in 'firstname', with: firstname
      fill_in 'lastname', with: lastname
      select(gender, from: 'gender')
      fill_in 'dob', with: dob
      fill_in 'height', with: height
      fill_in 'weight', with: weight
      fill_in 'phone', with: phone
      fill_in 'email', with: email
    end
    click_button 'Create Subject'
  end

  def new_report!(title = 'ReportTitle')
    visit "/reports/new?subject_id=#{Subject.last.id}"

    within("//form[@id='new_report']") do
      fill_in 'title', with: title
      attach_file('cpet_file_path', Rails.root.join('test/files/cpet.xlsx'))
      attach_file('rmr_file_path', Rails.root.join('test/files/rmr.xlsx'))
    end
    click_button 'Create Report'
  end

  def new_company!(name = 'CompanyName')
    visit '/companies/new'

    within("//form[@id='new_company']") do
      fill_in 'name', with: name
      fill_in 'address_1', with: 'address_1'
      fill_in 'address_2', with: 'address_2'
      fill_in 'city', with: 'city'
      fill_in 'postcode', with: 'postcode'
      fill_in 'country', with: 'country'
      fill_in 'email', with: 'email'
      fill_in 'phone', with: 'phone'
      attach_file('logo', Rails.root.join('test/images/logo.jpeg'))
    end
    click_button 'Create Company'
  end

  # to test that a new password "NewPassword" is actually saved
  # in the auth_meta_data of User for integration tests
  Tyrant::ResetPassword.class_eval do
    def generate_password!(options, *)
      options['new_password'] = 'NewPassword'
    end
  end

  # to test the email notification to the user for the ResetPassword
  # for integration tests
  Tyrant::Mailer.class_eval do
    def email_options!(_options, *)
      Pony.options = { via: :test }
    end
  end
end

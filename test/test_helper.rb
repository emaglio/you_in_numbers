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
require 'trailblazer/test/deprecation/operation/assertions'

Dir['./test/support/**/*.rb'].sort.each { |f| require f }

DatabaseCleaner.strategy = :transaction
Rails.application.config.trailblazer.enable_tracing = false # enable to troubleshoot v2.1 operations

Minitest::Spec.class_eval do
  include Trailblazer::Test::Assertions
  include Trailblazer::Test::Operation::Helper
  include Trailblazer::Test::Operation::Assertions
  include FactoryBot::Syntax::Methods

  FactoryBot.register_strategy(:trb_create, Support::TrbCreate)

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end

  def admin_for
    User.find_by(email: 'admin@email.com') ||
      User::Operation::Create.(
        params: {
          email: 'admin@email.com',
          password: 'password',
          confirm_password: 'password',
          firstname: 'Admin',
          admin: true
        }
      )[:model]
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
  include Support::CapybaraHelpers
  include Capybara::Screenshot::MiniTestPlugin

  def admin_for
    User.find_by(email: 'admin@email.com') ||
      User::Operation::Create.(
        params: {
          email: 'admin@email.com',
          password: 'password',
          confirm_password: 'password',
          firstname: 'Admin',
          admin: true
        }
      )[:model]
  end

  # to test that a new password "NewPassword" is actually saved
  # in the auth_meta_data of User for integration tests
  User::Operation::ResetPassword.class_eval do
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

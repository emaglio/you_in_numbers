# frozen_string_literal: true

require 'test_helper'

class NavigationMenuTest < Trailblazer::Test::Integration
  it 'top bar' do
    # no user logged in
    visit root_path

    _(find('.nav')).must_have_link 'Sign In'
    _(find('.nav')).must_have_link 'Sign Up'

    # normal user logged in
    log_in_as_user

    _(find('.navbar-top-links')).wont_have_link 'Sign In'
    _(find('.navbar-top-links')).wont_have_link 'Sign Up'
    _(find('.navbar-top-links')).must_have_link 'Hi, UserFirstname'
    _(find('.navbar-top-links')).must_have_link 'Settings'
    _(find('.navbar-top-links')).must_have_link 'Sign Out'
    _(find('.navbar-top-links')).must_have_link 'Account'
    _(find('.navbar-top-links')).must_have_link 'Company'
    _(find('.navbar-top-links')).must_have_link 'Report'
    _(find('.navbar-top-links')).wont_have_link 'Users'

    click_link 'Sign Out'

    # logged in as admin
    visit root_path
    log_in_as_admin

    # TODO: create more logic for admin and add the tests here
    _(find('.navbar-top-links')).wont_have_link 'Sign In'
    _(find('.navbar-top-links')).wont_have_link 'Sign Up'
    _(find('.navbar-top-links')).must_have_link 'Hi, Admin'
    _(find('.navbar-top-links')).must_have_link 'Settings'
    _(find('.navbar-top-links')).must_have_link 'Sign Out'
    _(find('.navbar-top-links')).must_have_link 'Account'
    _(find('.navbar-top-links')).must_have_link 'Company'
    _(find('.navbar-top-links')).must_have_link 'Report'
    _(find('.navbar-top-links')).must_have_link 'Users'
  end

  it 'side bar' do
    log_in_as_user

    _(find('.sidebar')).must_have_link 'Dashboard'
    _(find('.sidebar')).must_have_link 'Reports'
    _(find('.sidebar')).must_have_link 'My Reports'
    _(find('.sidebar')).must_have_link 'New Report'
    _(find('.sidebar')).must_have_link 'Subjects'
    _(find('.sidebar')).must_have_link 'My Subjects'
    _(find('.sidebar')).must_have_link 'New Subject'
  end
end

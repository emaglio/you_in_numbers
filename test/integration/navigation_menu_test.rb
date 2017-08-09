require 'test_helper'

class NavigationMenuTest < Trailblazer::Test::Integration

  it "top bar" do
    #no user logged in
    visit root_path

    find('.nav').must_have_link "Sign In"
    find('.nav').must_have_link "Sign Up"
    find('.nav').must_have_link "Download"
    find('.nav').must_have_link "Features"
    find('.nav').must_have_link "Contact"

    #normal user logged in
    log_in_as_user

    find('.navbar-top-links').wont_have_link "Sign In"
    find('.navbar-top-links').wont_have_link "Sign Up"
    find('.navbar-top-links').must_have_link "Hi, UserFirstname"
    find('.navbar-top-links').must_have_link "Settings"
    find('.navbar-top-links').must_have_link "Sign Out"
    find('.navbar-top-links').must_have_link "Account"
    find('.navbar-top-links').must_have_link "Company"
    find('.navbar-top-links').must_have_link "Report"
    find('.navbar-top-links').wont_have_link "Users"


    click_link "Sign Out"

    #logged in as admin
    visit root_path
    log_in_as_admin

    # TODO: create more logic for admin and add the tests here
    find('.navbar-top-links').wont_have_link "Sign In"
    find('.navbar-top-links').wont_have_link "Sign Up"
    find('.navbar-top-links').must_have_link "Hi, Admin"
    find('.navbar-top-links').must_have_link "Settings"
    find('.navbar-top-links').must_have_link "Sign Out"
    find('.navbar-top-links').must_have_link "Account"
    find('.navbar-top-links').must_have_link "Company"
    find('.navbar-top-links').must_have_link "Report"
    find('.navbar-top-links').must_have_link "Users"
  end

  it "side bar" do
    log_in_as_user

    find('.sidebar').must_have_link "Dashboard"
    find('.sidebar').must_have_link "Reports"
    find('.sidebar').must_have_link "My Reports"
    find('.sidebar').must_have_link "New Report"
    find('.sidebar').must_have_link "Subjects"
    find('.sidebar').must_have_link "My Subjects"
    find('.sidebar').must_have_link "New Subject"
  end

end

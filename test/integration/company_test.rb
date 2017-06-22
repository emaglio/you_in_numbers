require 'test_helper'

class CompanyTest < Trailblazer::Test::Integration

  it "Company from scratch" do
    log_in_as_user

    visit "/users/#{User.last.id}"

    page.must_have_content "Company details"
    page.must_have_content "Your company details has not been set!"
    page.must_have_button "Update details"

    click_button "Update details"

    page.must_have_css "#name"
    page.must_have_css "#address_1"
    page.must_have_css "#address_2"
    page.must_have_css "#city"
    page.must_have_css "#postcode"
    page.must_have_css "#country"
    page.must_have_css "#email"
    page.must_have_css "#phone"
    page.must_have_css "#website"
    page.must_have_css "#website"
    page.must_have_selector("input[type=file][name=logo]")
    page.must_have_button "Create Company"

    within("//form[@id='new_company']") do
      fill_in 'Name',    with: "My Company"
    end
    click_button "Create Company"

    page.wont_have_content "Your company details has not been set!"
    page.wont_have_button "Update details"

    page.must_have_content "Company details updated!"
    page.must_have_content "No logo"
    page.must_have_button "Edit"
    page.must_have_button "Delete"
    page.must_have_button "Upload Logo"



  end

end

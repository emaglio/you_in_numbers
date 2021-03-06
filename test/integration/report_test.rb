# frozen_string_literal: true

require 'test_helper'

class ReportIntegrationTest < Trailblazer::Test::Integration
  describe 'CRUD report' do
    it 'Create report only if subject is select' do
      skip 'need to fix this'
      log_in_as_user

      click_link 'New Report'

      _(page).must_have_content 'Select an existing Subject or'
      _(page).must_have_button 'Create a new one'

      click_button 'Create a new one'

      _(page.current_path).must_equal '/subjects/new'

      new_subject!

      visit '/reports/new?subject_id=1'

      _(page).must_have_content 'New Report'
      _(page).must_have_content 'Subject details'
      _(page).must_have_content 'SubjectFirstname'
      _(page).must_have_content 'SubjectLastname'
      _(page).must_have_css '#height'
      _(page).must_have_css '#weight'
      _(page).must_have_button 'Save Changes'
      _(page).must_have_css '#title'
      _(page).must_have_css '#cpet_file_path'
      _(page).must_have_css '#rmr_file_path'
      _(page).must_have_css '#template'
      _(page).must_have_button 'Create Report'

      # test error messages
      click_button 'Create Report'
      _(page).must_have_content 'At least one file must be uploaded'

      within("//form[@id='new_report']") do
        fill_in 'title', with: 'ReportTitle'
        attach_file('cpet_file_path', Rails.root.join('test/files/cpet.xlsx'))
        attach_file('rmr_file_path', Rails.root.join('test/files/rmr.xlsx'))
      end
      click_button 'Create Report'

      _(page).must_have_content 'Report created'
      _(page).must_have_content 'ReportTitle'
      _(page).must_have_css '#template'
      _(page).must_have_button 'Update Template'
      _(page).must_have_button 'Edit AT'
      _(page).must_have_button 'Edit VO2max'
      _(page).must_have_button 'Generate Report'

      _(page.current_path).must_equal "/reports/#{Report.last.id}"

      click_button 'Generate Report'
    end

    it 'Generate report only if company is created' do
      log_in_as_user

      new_subject!

      new_report!

      # TODO: find a way to click the Generate Report button to actually create the report

      # click_button "Generate Report"

      # page.must_have_content "Create a company and try to generate the report again!"
      # page.current_path.must_equal "/companies/new"
    end
  end

  describe 'Edit AT and VO2max' do
    it 'Test edit AT' do
      log_in_as_user

      new_subject!

      new_report!

      click_button 'Edit AT'

      _(page).must_have_content 'Edit AT'
      _(page).must_have_content 'Click on either charts to move the AT point'
      _(page).must_have_content 'VCO2 on VO2'
      _(page).must_have_content 'VE/VCO2 and VE/VO2 on time'
      _(page).must_have_button 'Restore AT'
      _(page).must_have_button 'Save & Exit'
      _(page.current_path).must_equal "/reports/#{Report.last.id}/edit_at"

      # TODO: find a way to click on the graph to test the AT changing
    end

    it 'Test edit VO2max' do
      log_in_as_user

      new_subject!

      new_report!

      click_button 'Edit VO2max'

      _(page).must_have_content 'Left click to move the starting point and right click ' \
                             'to move the end point of the VO2max range'
      _(page).must_have_content 'VO2max details:'
      _(page).must_have_css '#starts'
      _(page).must_have_css '#ends'
      _(page).must_have_css '#value'
      _(page).must_have_content 'VO2 on time'

      # TODO: find a way to click on the graph to test the VO2max changing
    end
  end
end # class ReportIntegrationTest

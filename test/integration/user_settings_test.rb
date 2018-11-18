require 'test_helper'

class UserSettingsIntegrationTest < Trailblazer::Test::Integration
  describe 'User report settings/template' do
    it "edit settings" do
      log_in_as_user("my@email.com", "password")

      page.must_have_content "Hi, UserFirstname"

      user = User.find_by(email: 'my@email.com')

      visit "/users/#{user.id}/settings"

      page.must_have_content "Report Settings"
      page.must_have_button "Edit"
      page.must_have_content "Subject Settings"
      page.must_have_content "Parameters list"
      page.must_have_content "Ergometer Parameters"
      page.must_have_content "Training Zones Levels"
      page.must_have_content  "cm"
      page.must_have_content  "kg"
      page.must_have_content  "Power"
      page.must_have_content  "Watt"
      page.must_have_content  "Revolution"
      page.must_have_content  "RPM"
      page.must_have_content  "35"
      page.must_have_content  "50"
      page.must_have_content  "51"
      page.must_have_content  "75"
      page.must_have_content  "76"
      page.must_have_content  "90"
      page.must_have_content  "91"
      page.must_have_content  "100"

      first('.button_to').click_button("Edit")
      page.must_have_content "Report Settings"
      page.must_have_css '#um_height'
      page.must_have_css '#um_weight'
      page.must_have_css '#params_list'
      page.must_have_css '#load_1'
      page.must_have_css '#load_1_um'
      page.must_have_css '#load_2'
      page.must_have_css '#load_2_um'
      page.must_have_css '#fat_burning_1'
      page.must_have_css '#level2'
      page.must_have_css '#level3'
      page.must_have_css '#level4'
      page.must_have_css '#level5'
      page.must_have_css '#level6'
      page.must_have_css '#level7'
      page.must_have_css '#vo2max_2'
      page.must_have_button "Save"
      page.must_have_button "Default Settings"

      within("//form[@id='report_settings']") do
        select('in', from: 'um_height')
        select('lbs', from: 'um_weight')
        fill_in 'params_list', with: "Param1,Param2,Param3"
        fill_in 'load_1', with: "load_1"
        fill_in 'load_1_um', with: "load_1_um"
        fill_in 'load_2', with: "load_2"
        fill_in 'load_2_um', with: "load_2_um"
        select('49', from: 'level2')
        select('65', from: 'level3')
        select('74', from: 'level4')
        select('80', from: 'level5')
        select('85', from: 'level6')
        select('95', from: 'level7')
      end
      click_button "Save"

      page.current_path.must_equal "/users/#{user.id}/settings"

      page.must_have_content  "in"
      page.must_have_content  "lbs"
      page.must_have_content  "Param1 - Param2 - Param3"
      page.must_have_content  "load_1"
      page.must_have_content  "load_1_um"
      page.must_have_content  "load_2"
      page.must_have_content  "load_2_um"
      page.must_have_content  "35"
      page.must_have_content  "49"
      page.must_have_content  "65"
      page.must_have_content  "74"
      page.must_have_content  "80"
      page.must_have_content  "85"
      page.must_have_content  "95"
      page.must_have_content  "100"

      # test validations
      first('.button_to').click_button("Edit")

      within("//form[@id='report_settings']") do
        fill_in 'params_list', with: ""
        select('2', from: 'level2')
        select('2', from: 'level4')
      end
      click_button "Save"

      page.must_have_content "Can't be blank"
      page.must_have_content "This must be greater than 35"
      page.must_have_content "This range was wrong or over the previous one"
    end

    it "edit template" do
      log_in_as_user("my@email.com", "password")
      page.must_have_content "Hi, UserFirstname"

      user = User.find_by(email: 'my@email.com')

      subject = Subject::Create.(
        {
          user_id: user.id,
          firstname: "Ema",
          lastname: "Maglio",
          gender: "Male",
          dob: "01/01/1980",
          height: "180",
          weight: "80",
          phone: "912873",
          email: "ema@email.com"
        }, "current_user" => user
      )["model"]

      upload_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: File.new(Rails.root.join("test/files/cpet.xlsx"))
      )

      Report::Create.(
        {
          user_id: user.id,
          subject_id: subject.id,
          title: "My report",
          cpet_file_path: upload_file,
          template: "default"
        }, "current_user" => user
      )

      visit "/users/#{user.id}/settings"

      within('.default_template') do
        page.must_have_content "Default"
        page.must_have_content "VO2 and VCO2 on time"
        page.must_have_content "HR, Power and Ve on time"
        page.must_have_content "VO2max Test Summary"
        page.must_have_content "Training Zones"
        page.wont_have_button "Edit"
      end

      within('.custom_template') do
        page.must_have_content "Custom"
        page.must_have_content "VO2 and VCO2 on time"
        page.must_have_content "HR, Power and Ve on time"
        page.must_have_content "VO2max Test Summary"
        page.must_have_content "Training Zones"
      end

      page.all('.button_to')[1].click_button("Edit")
      page.current_path.must_equal "/users/#{user.id}/get_report_template"

      # first element not having the UP button
      within(page.all('#forms_0')[0]) do
        page.must_have_css '#type'
        page.must_have_button 'Add it'
        page.must_have_button 'Delete'
        page.must_have_button 'Edit'
        page.must_have_css '#move_down'
        page.wont_have_css '#move_up'
      end

      # last element not having the DOWN button
      # training zones element no Edit button as well
      within('#forms_3') do
        page.must_have_css '#type'
        page.must_have_button 'Add it'
        page.must_have_button 'Delete'
        page.wont_have_button 'Edit'
        page.wont_have_css '#move_down'
        page.must_have_css '#move_up'
      end

      within(page.all('#forms_0')[0]) do
        click_button "Edit"
      end

      # edit chart test
      page.current_path.must_equal "/users/#{user.id}/edit_chart"

      page.must_have_css "#title"
      page.must_have_css "#edit_chart"
      page.must_have_css "#y1_select"
      page.must_have_css "#y1_colour"
      page.must_have_css "#y1_scale"
      page.must_have_css "#y2_select"
      page.must_have_css "#y2_colour"
      page.must_have_css "#y2_scale"
      page.must_have_css "#y3_select"
      page.must_have_css "#y3_colour"
      page.must_have_css "#y3_scale"
      page.must_have_css "#x"
      page.must_have_css "#x_time"
      page.must_have_css "#x_format"
      page.must_have_css "#vo2max_show"
      page.must_have_css "#vo2max_colour"
      page.must_have_css "#exer_show"
      page.must_have_css "#exer_colour"
      page.must_have_css "#at_show"
      page.must_have_css "#at_colour"
      page.must_have_css "#only_exer"
      page.must_have_button "Save Changes"
      page.must_have_button "Back"

      click_button "Back"
      page.current_path.must_equal "/users/#{user.id}/get_report_template"
      visit "/users/#{user.id}/edit_chart?edit_chart=0"

      within("//form[@id='edit_chart']") do
        fill_in "title", with: "Edited chart"
        select("VO2", from: 'y1_select')
        check "y1_scale"
      end
      click_button "Save Changes"

      page.must_have_content "Chart updated!"
      page.current_path.must_equal "/users/#{user.id}/get_report_template"

      page.must_have_content "Edited chart"
      page.wont_have_content "VO2 and VCO2 on time"

      visit "/users/#{user.id}/settings"

      within('.custom_template') do
        page.wont_have_content "VO2 and VCO2 on time"
        page.must_have_content "Edited chart"
      end

      # delete object
      visit "/users/#{user.id}/get_report_template"

      within(page.all('#forms_0')[0]) do
        click_button "Delete"
      end
      page.must_have_content "Report template updated!"

      page.wont_have_content "Edited chart"
      page.wont_have_content "VO2 and VCO2 on time"

      visit "/users/#{user.id}/settings"
      within('.custom_template') do
        page.wont_have_content "VO2 and VCO2 on time"
        page.wont_have_content "Edited chart"
      end

      # add obj
      visit "/users/#{user.id}/get_report_template"

      within(page.all('#forms_0')[0]) do
        select("Chart", from: 'type')
        click_button "Add it"
      end
      page.must_have_content "Report template updated!"

      page.must_have_content "VO2 and VCO2 on time"

      visit "/users/#{user.id}/settings"
      within('.custom_template') do
        page.must_have_content "VO2 and VCO2 on time"
      end

      # edit summary table
      visit "/users/#{user.id}/get_report_template"

      within('#forms_2') do
        click_button "Edit"
      end

      page.current_path.must_equal "/users/#{user.id}/edit_table"

      page.must_have_css "#title"
      page.must_have_css "#params_list"
      page.must_have_css "#unm_list"
      page.must_have_button "Save Changes"
      page.must_have_button "Back"

      within("//form[@id='edit_table']") do
        fill_in "title", with: "Edited table"
        fill_in "params_list", with: "t,RQ"
        fill_in "unm_list", with: "mm::ss,-"
      end
      click_button "Save Changes"

      page.must_have_content "Table updated!"

      page.wont_have_content "VO2max Test Summary"
      page.must_have_content "Edited table"

      visit "/users/#{user.id}/settings"
      within('.custom_template') do
        page.wont_have_content "VO2max Test Summary"
        page.must_have_content "Edited table"
      end

      # move obj down
      visit "/users/#{user.id}/get_report_template"

      User.find(user.id).content["report_template"]["custom"][0][:title].must_equal "VO2 and VCO2 on time"

      within(page.all('#forms_0')[0]) do
        find('#move_down').click
      end
      page.must_have_content "Report template updated!"

      User.find(user.id).content["report_template"]["custom"][0][:title].wont_equal "VO2 and VCO2 on time"
      User.find(user.id).content["report_template"]["custom"][0][:title].must_equal "HR, Power and Ve on time"

      # move obj up
      visit "/users/#{user.id}/get_report_template"

      User.find(user.id).content["report_template"]["custom"][0][:title].must_equal "HR, Power and Ve on time"

      within('#forms_1') do
        find('#move_up').click
      end
      page.must_have_content "Report template updated!"

      User.find(user.id).content["report_template"]["custom"][0][:title].must_equal "VO2 and VCO2 on time"
      User.find(user.id).content["report_template"]["custom"][0][:title].wont_equal "HR, Power and Ve on time"
    end
  end

  describe "Test unit of measurements for User" do
    it "test it" do
      log_in_as_user

      user = User.find_by(email: 'my@email.com')

      new_subject!

      visit "/reports/new?subject_id=#{Subject.last.id}"

      page.must_have_content "Height (cm)"
      page.must_have_content "Weight (kg)"

      visit "/users/#{user.id}/settings"

      first('.button_to').click_button("Edit")

      within("//form[@id='report_settings']") do
        select('in', from: 'um_height')
        select('lbs', from: 'um_weight')
      end
      click_button "Save"

      visit "/reports/new?subject_id=#{Subject.last.id}"

      page.must_have_content "Height (in)"
      page.must_have_content "Weight (lbs)"
    end
  end
end

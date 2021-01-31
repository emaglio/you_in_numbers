# frozen_string_literal: true

require 'test_helper'

class UserSettingsIntegrationTest < Trailblazer::Test::Integration
  describe 'User report settings/template' do
    it 'edit settings' do
      log_in_as_user('my@email.com', 'password')

      _(page).must_have_content 'Hi, UserFirstname'

      user = User.find_by(email: 'my@email.com')

      visit "/users/#{user.id}/settings"

      _(page).must_have_content 'Report Settings'
      _(page).must_have_button 'Edit'
      _(page).must_have_content 'Subject Settings'
      _(page).must_have_content 'Parameters list'
      _(page).must_have_content 'Ergometer Parameters'
      _(page).must_have_content 'Training Zones Levels'
      _(page).must_have_content  'cm'
      _(page).must_have_content  'kg'
      _(page).must_have_content  'Power'
      _(page).must_have_content  'Watt'
      _(page).must_have_content  'Revolution'
      _(page).must_have_content  'RPM'
      _(page).must_have_content  '35'
      _(page).must_have_content  '50'
      _(page).must_have_content  '51'
      _(page).must_have_content  '75'
      _(page).must_have_content  '76'
      _(page).must_have_content  '90'
      _(page).must_have_content  '91'
      _(page).must_have_content  '100'

      first('.button_to').click_button('Edit')
      _(page).must_have_content 'Report Settings'
      _(page).must_have_css '#um_height'
      _(page).must_have_css '#um_weight'
      _(page).must_have_css '#params_list'
      _(page).must_have_css '#load_1'
      _(page).must_have_css '#load_1_um'
      _(page).must_have_css '#load_2'
      _(page).must_have_css '#load_2_um'
      _(page).must_have_css '#fat_burning_1'
      _(page).must_have_css '#level2'
      _(page).must_have_css '#level3'
      _(page).must_have_css '#level4'
      _(page).must_have_css '#level5'
      _(page).must_have_css '#level6'
      _(page).must_have_css '#level7'
      _(page).must_have_css '#vo2max_2'
      _(page).must_have_button 'Save'
      _(page).must_have_button 'Default Settings'

      within("//form[@id='report_settings']") do
        select('in', from: 'um_height')
        select('lbs', from: 'um_weight')
        fill_in 'params_list', with: 'Param1,Param2,Param3'
        fill_in 'load_1', with: 'load_1'
        fill_in 'load_1_um', with: 'load_1_um'
        fill_in 'load_2', with: 'load_2'
        fill_in 'load_2_um', with: 'load_2_um'
        select('49', from: 'level2')
        select('65', from: 'level3')
        select('74', from: 'level4')
        select('80', from: 'level5')
        select('85', from: 'level6')
        select('95', from: 'level7')
      end
      click_button 'Save'

      _(page.current_path).must_equal "/users/#{user.id}/settings"

      _(page).must_have_content  'in'
      _(page).must_have_content  'lbs'
      _(page).must_have_content  'Param1 - Param2 - Param3'
      _(page).must_have_content  'load_1'
      _(page).must_have_content  'load_1_um'
      _(page).must_have_content  'load_2'
      _(page).must_have_content  'load_2_um'
      _(page).must_have_content  '35'
      _(page).must_have_content  '49'
      _(page).must_have_content  '65'
      _(page).must_have_content  '74'
      _(page).must_have_content  '80'
      _(page).must_have_content  '85'
      _(page).must_have_content  '95'
      _(page).must_have_content  '100'

      # test validations
      first('.button_to').click_button('Edit')

      within("//form[@id='report_settings']") do
        fill_in 'params_list', with: ''
        select('2', from: 'level2')
        select('2', from: 'level4')
      end
      click_button 'Save'

      _(page).must_have_content "Can't be blank"
      _(page).must_have_content 'This must be greater than 35'
      _(page).must_have_content 'This range was wrong or over the previous one'
    end

    it 'edit template' do
      skip 'need to fix this'
      log_in_as_user('my@email.com', 'password')
      _(page).must_have_content 'Hi, UserFirstname'

      user = User.find_by(email: 'my@email.com')

      subject = Subject::Create.(
        {
          user_id: user.id,
          firstname: 'Ema',
          lastname: 'Maglio',
          gender: 'Male',
          dob: '01/01/1980',
          height: '180',
          weight: '80',
          phone: '912873',
          email: 'ema@email.com'
        }, 'current_user' => user
      )['model']

      upload_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: File.new(Rails.root.join('test/files/cpet.xlsx'))
      )

      Report::Create.(
        {
          user_id: user.id,
          subject_id: subject.id,
          title: 'My report',
          cpet_file_path: upload_file,
          template: 'default'
        }, 'current_user' => user
      )

      visit "/users/#{user.id}/settings"

      within('.default_template') do
        _(page).must_have_content 'Default'
        _(page).must_have_content 'VO2 and VCO2 on time'
        _(page).must_have_content 'HR, Power and Ve on time'
        _(page).must_have_content 'VO2max Test Summary'
        _(page).must_have_content 'Training Zones'
        _(page).wont_have_button 'Edit'
      end

      within('.custom_template') do
        _(page).must_have_content 'Custom'
        _(page).must_have_content 'VO2 and VCO2 on time'
        _(page).must_have_content 'HR, Power and Ve on time'
        _(page).must_have_content 'VO2max Test Summary'
        _(page).must_have_content 'Training Zones'
      end

      page.all('.button_to')[1].click_button('Edit')
      _(page.current_path).must_equal "/users/#{user.id}/get_report_template"

      # first element not having the UP button
      within(page.all('#forms_0')[0]) do
        _(page).must_have_css '#type'
        _(page).must_have_button 'Add it'
        _(page).must_have_button 'Delete'
        _(page).must_have_button 'Edit'
        _(page).must_have_css '#move_down'
        _(page).wont_have_css '#move_up'
      end

      # last element not having the DOWN button
      # training zones element no Edit button as well
      within('#forms_3') do
        _(page).must_have_css '#type'
        _(page).must_have_button 'Add it'
        _(page).must_have_button 'Delete'
        _(page).wont_have_button 'Edit'
        _(page).wont_have_css '#move_down'
        _(page).must_have_css '#move_up'
      end

      within(page.all('#forms_0')[0]) do
        click_button 'Edit'
      end

      # edit chart test
      _(page.current_path).must_equal "/users/#{user.id}/edit_chart"

      _(page).must_have_css '#title'
      _(page).must_have_css '#edit_chart'
      _(page).must_have_css '#y1_select'
      _(page).must_have_css '#y1_colour'
      _(page).must_have_css '#y1_scale'
      _(page).must_have_css '#y2_select'
      _(page).must_have_css '#y2_colour'
      _(page).must_have_css '#y2_scale'
      _(page).must_have_css '#y3_select'
      _(page).must_have_css '#y3_colour'
      _(page).must_have_css '#y3_scale'
      _(page).must_have_css '#x'
      _(page).must_have_css '#x_time'
      _(page).must_have_css '#x_format'
      _(page).must_have_css '#vo2max_show'
      _(page).must_have_css '#vo2max_colour'
      _(page).must_have_css '#exer_show'
      _(page).must_have_css '#exer_colour'
      _(page).must_have_css '#at_show'
      _(page).must_have_css '#at_colour'
      _(page).must_have_css '#only_exer'
      _(page).must_have_button 'Save Changes'
      _(page).must_have_button 'Back'

      click_button 'Back'
      _(page.current_path).must_equal "/users/#{user.id}/get_report_template"
      visit "/users/#{user.id}/edit_chart?edit_chart=0"

      within("//form[@id='edit_chart']") do
        fill_in 'title', with: 'Edited chart'
        select('VO2', from: 'y1_select')
        check 'y1_scale'
      end
      click_button 'Save Changes'

      _(page).must_have_content 'Chart updated!'
      _(page.current_path).must_equal "/users/#{user.id}/get_report_template"

      _(page).must_have_content 'Edited chart'
      page.wont_have_content 'VO2 and VCO2 on time'

      visit "/users/#{user.id}/settings"

      within('.custom_template') do
        page.wont_have_content 'VO2 and VCO2 on time'
        _(page).must_have_content 'Edited chart'
      end

      # delete object
      visit "/users/#{user.id}/get_report_template"

      within(page.all('#forms_0')[0]) do
        click_button 'Delete'
      end
      _(page).must_have_content 'Report template updated!'

      page.wont_have_content 'Edited chart'
      page.wont_have_content 'VO2 and VCO2 on time'

      visit "/users/#{user.id}/settings"
      within('.custom_template') do
        page.wont_have_content 'VO2 and VCO2 on time'
        page.wont_have_content 'Edited chart'
      end

      # add obj
      visit "/users/#{user.id}/get_report_template"

      within(page.all('#forms_0')[0]) do
        select('Chart', from: 'type')
        click_button 'Add it'
      end
      _(page).must_have_content 'Report template updated!'

      _(page).must_have_content 'VO2 and VCO2 on time'

      visit "/users/#{user.id}/settings"
      within('.custom_template') do
        _(page).must_have_content 'VO2 and VCO2 on time'
      end

      # edit summary table
      visit "/users/#{user.id}/get_report_template"

      within('#forms_2') do
        click_button 'Edit'
      end

      _(page.current_path).must_equal "/users/#{user.id}/edit_table"

      _(page).must_have_css '#title'
      _(page).must_have_css '#params_list'
      _(page).must_have_css '#unm_list'
      _(page).must_have_button 'Save Changes'
      _(page).must_have_button 'Back'

      within("//form[@id='edit_table']") do
        fill_in 'title', with: 'Edited table'
        fill_in 'params_list', with: 't,RQ'
        fill_in 'unm_list', with: 'mm::ss,-'
      end
      click_button 'Save Changes'

      _(page).must_have_content 'Table updated!'

      page.wont_have_content 'VO2max Test Summary'
      _(page).must_have_content 'Edited table'

      visit "/users/#{user.id}/settings"
      within('.custom_template') do
        page.wont_have_content 'VO2max Test Summary'
        _(page).must_have_content 'Edited table'
      end

      # move obj down
      visit "/users/#{user.id}/get_report_template"

      User.find(user.id).content['report_template']['custom'][0][:title].must_equal 'VO2 and VCO2 on time'

      within(page.all('#forms_0')[0]) do
        find('#move_down').click
      end
      _(page).must_have_content 'Report template updated!'

      User.find(user.id).content['report_template']['custom'][0][:title].wont_equal 'VO2 and VCO2 on time'
      User.find(user.id).content['report_template']['custom'][0][:title].must_equal 'HR, Power and Ve on time'

      # move obj up
      visit "/users/#{user.id}/get_report_template"

      User.find(user.id).content['report_template']['custom'][0][:title].must_equal 'HR, Power and Ve on time'

      within('#forms_1') do
        find('#move_up').click
      end
      _(page).must_have_content 'Report template updated!'

      User.find(user.id).content['report_template']['custom'][0][:title].must_equal 'VO2 and VCO2 on time'
      User.find(user.id).content['report_template']['custom'][0][:title].wont_equal 'HR, Power and Ve on time'
    end
  end

  describe 'Test unit of measurements for User' do
    it 'test it' do
      log_in_as_user

      user = User.find_by(email: 'my@email.com')

      new_subject!

      visit "/reports/new?subject_id=#{Subject.last.id}"

      _(page).must_have_content 'Height (cm)'
      _(page).must_have_content 'Weight (kg)'

      visit "/users/#{user.id}/settings"

      first('.button_to').click_button('Edit')

      within("//form[@id='report_settings']") do
        select('in', from: 'um_height')
        select('lbs', from: 'um_weight')
      end
      click_button 'Save'

      visit "/reports/new?subject_id=#{Subject.last.id}"

      _(page).must_have_content 'Height (in)'
      _(page).must_have_content 'Weight (lbs)'
    end
  end
end

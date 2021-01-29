# frozen_string_literal: true

require 'test_helper'

class SessionsIntegrationTest < Trailblazer::Test::Integration
  it 'invalid log in (not existing)' do
    visit 'sessions/new'

    submit!('', '')

    _(page).must_have_css '#email'
    _(page).must_have_css '#password'
    _(page).must_have_content "Can't be blank"
    _(page).must_have_button 'Sign In'

    submit!('wrong@email.com', 'wrong')

    _(page).must_have_content 'User not found'
    _(page).must_have_css '#email'
    _(page).must_have_css '#password'
    _(page).must_have_button 'Sign In'
    _(page).must_have_content 'User not found'
    _(page.current_path).must_equal sessions_path
  end

  it 'successfully log in' do
    user = User::Create.(
      email: 'test@email.com', password: 'password', confirm_password: 'password', firstname: 'NewUser'
    )['model']

    visit 'sessions/new'

    submit!(user.email.to_s, 'password')

    _(page).must_have_content 'Hi, NewUser'
    _(page).must_have_link 'Sign Out'
    _(page).wont_have_css '#email'
    _(page).wont_have_css '#password'
    _(page).wont_have_button 'Sign In'
    _(page.current_path).must_equal reports_path

    _(page).must_have_content 'Hey mate, welcome back!'
  end

  it 'succesfully log out' do
    user = User::Create.(
      email: 'test@email.com', password: 'password', confirm_password: 'password', firstname: 'NewUser'
    )['model']

    visit 'sessions/new'

    submit!(user.email.to_s, 'password')

    _(page).must_have_content 'Hi, NewUser'
    _(page).must_have_link 'Sign Out'

    click_link 'Sign Out'
    _(page).wont_have_content 'Hi, NewUser'
    _(page).must_have_content 'See ya!'
  end
end

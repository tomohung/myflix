require 'spec_helper'

feature 'User resets password' do
  scenario 'user successfully resets the password' do
    clear_emails

    user = Fabricate(:user)
    visit sign_in_path
    click_link 'Forgot Password?'

    fill_in 'Email Address', with: user.email
    click_button 'Send Email'

    open_email(user.email)
    current_email.click_link("Reset Password")

    fill_in 'New Password', with: 'new_password'
    click_button 'Reset Password'

    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: 'new_password'
    click_button 'Sign in'
    expect(page).to have_content("Welcome, #{user.full_name}")
  end

  
end
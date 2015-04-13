require 'spec_helper'
require 'stripe_mock'
feature 'User invites friend' do

  let(:stripe_helper) { StripeMock.create_test_helper }
  after { StripeMock.stop }

  before { StripeMock.start }

  scenario 'User successfully invites friend and invitation is accepted' do
    user = Fabricate(:user)
    sign_in(user)

    visit new_invitation_path
    fill_in "Friend's Name", with: 'Joe'
    fill_in "Friend's Email", with: 'joe@example.com'
    fill_in "message", with: 'come to join myflix.'
    click_button 'Send Invitation'
    sign_out

    open_email 'joe@example.com'
    current_email.click_link 'Accept Invitation'

    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Joe'
    click_button 'Sign Up'
    
    click_link 'People'
    expect(page).to have_content user.full_name
    sign_out

    sign_in(user)
    click_link 'People'
    expect(page).to have_content 'Joe'
    clear_email
  end

end

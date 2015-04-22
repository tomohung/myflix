require 'spec_helper'

feature 'User invites friend' do

  scenario 'User successfully invites friend and invitation is accepted', {js: true, vcr: true, driver: :selenium} do
    user = Fabricate(:user)
    sign_in(user)

    visit new_invitation_path
    fill_in "Friend's Name", with: 'Joe'
    fill_in "Friend's Email", with: 'joe@example.com'
    fill_in "message", with: 'come to join myflix.'
    click_button 'Send Invitation'

    open_email 'joe@example.com'
    current_email.click_link 'Accept Invitation'

    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: 'Joe'

    card_number = '4242424242424242'
    cvc = '145'
    fill_in 'Credit Card Number', with: card_number
    fill_in 'Security Code', with: cvc
    select '4 - April', from: 'date_month'
    select '2019', from: 'date_year'
    click_button 'Sign Up'

    click_link 'People'
    expect(page).to have_content user.full_name
    
    visit home_path
    sign_out
    
    sign_in(user)
    click_link 'People'
    expect(page).to have_content 'Joe'
    clear_email
  end

end

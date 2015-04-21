require 'spec_helper'

feature 'user register a new account', { js: true, vcr: true } do
  scenario 'with valid card info' do
    visit register_path
    fill_in 'Email Address', with: 'fred@example.com'
    fill_in 'Password', with: 'fff'
    fill_in 'Full Name', with: 'Fred'

    card_number = '4242424242424242'
    cvc = '145'
    fill_in 'Credit Card Number', with: card_number
    fill_in 'Security Code', with: cvc
    select '4 - April', from: 'date_month'
    select '2019', from: 'date_year'
    click_button 'Sign Up'

    expect(page).to have_content 'Sign in'
  end

  scenario 'with invalid card info' do
    visit register_path
    fill_in 'Email Address', with: 'fred@example.com'
    fill_in 'Password', with: 'fff'
    fill_in 'Full Name', with: 'Fred'

    card_number = '4000000000000002'
    cvc = '145'
    fill_in 'Credit Card Number', with: card_number
    fill_in 'Security Code', with: cvc
    select '4 - April', from: 'date_month'
    select '2019', from: 'date_year'
    click_button 'Sign Up'  

    expect(page).to have_content 'Your card was declined.'
  end
end

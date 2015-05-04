require 'spec_helper'

feature 'Admin sees payments' do
  scenario 'admin can see payments' do
    user = Fabricate(:user)
    payment = Payment.create(user: user, reference_id: 'abcd', amount: 99)
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect(page).to have_content("$0.99")
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.full_name)
    expect(page).to have_content('abcd')
  end

  scenario 'user cannot see payments' do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect(page).to have_content("You do not have access right.")
  end
end

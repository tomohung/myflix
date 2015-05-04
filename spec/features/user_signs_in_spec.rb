require 'spec_helper'

feature 'user signs in' do
  scenario 'with existing username' do
    sign_in
    expect(page).to have_content("You have signed in.")
  end

  scenario 'deactivates an active user' do
    user = Fabricate(:user, active: false)
    sign_in(user)
    expect(page).not_to have_content(user.full_name)
    expect(page).to have_content("Your account has been suspended.")
  end
end

feature 'user signs in with js: true' do
  scenario 'with existing username', js: true do
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content("You have signed in.")
  end
end



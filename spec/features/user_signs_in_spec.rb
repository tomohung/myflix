require 'spec_helper'

feature 'user signs in' do
  scenario 'with existing username' do
    sign_in
    expect(page).to have_content("You have signed in.")
  end
end
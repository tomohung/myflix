require 'spec_helper'

feature 'User following' do
  scenario 'user follows and unfollows' do
    amy = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    Fabricate(:review, user: amy, video: video)

    sign_in
    click_on_video_on_home_page(video)
    click_link amy.full_name
    click_link "Follow"

    expect(page).to have_content(amy.full_name)
    within 'table' do
     unfollow
    end
    expect(page).not_to have_content(amy.full_name)
  end  
end

def unfollow
  find("a[data-method='delete']").click
end


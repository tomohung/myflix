require 'spec_helper'

feature 'user interacts with the queue' do 

  scenario 'user adds and reorder videos in the queue' do
    category    = Fabricate(:category)
    monk        = Fabricate(:video, title: 'monk', category: category)
    futurama    = Fabricate(:video, title: 'futurama', category: category)
    south_park  = Fabricate(:video, title: 'south park', category: category)

    sign_in
    expect(page).to have_content 'You have signed in.'

    add_video_to_queue(monk)
    expect(page).to have_content(monk.title)

    visit video_path(monk)
    expect(page).not_to have_content('+ My Queue')

    add_video_to_queue(futurama)
    add_video_to_queue(south_park)

    set_video_order(monk, 3)
    set_video_order(futurama, 1)
    set_video_order(south_park, 2)

    expect_video_order(monk, 3)
    expect_video_order(futurama, 1)
    expect_video_order(south_park, 2)
  end
end

def add_video_to_queue(video)
  visit home_path
  find("a[href='/videos/#{video.id}']").click
  expect(page).to have_content(video.title)
  click_link '+ My Queue'
end

def set_video_order(video, order)
  within(:xpath, "//tr[contains(.,'#{video.title}')]") do
    fill_in 'queue_items[][position]', with: order
  end
end

def expect_video_order(video, order)
  expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(order.to_s)
end

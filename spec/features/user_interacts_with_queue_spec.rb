require 'rails_helper'

  feature "User interacts with the queue" do

    scenario "User adds and reorders videos in the queue" do

    comedy = Fabricate(:category)
    video1 = Fabricate(:video, category: comedy)
    video2 = Fabricate(:video, category: comedy)
    video3 = Fabricate(:video, category: comedy)

    sign_in
    expect(page).to have_content User.first.name

    find("a[href='/videos/#{video1.id}']").click
    expect(page).to have_content video1.title

    click_link('+ My Queue')
    expect(page).to have_content video1.title
    expect(page).not_to have_content "Watch Now"

    click_link(video1.title)
    expect(page).not_to have_link '+ My Queue'

    visit home_path
    find("a[href='/videos/#{video2.id}']").click
    click_link('+ My Queue')
    expect(page).to have_content video2.title
    expect(page).not_to have_content "Watch Now"

    visit home_path
    find("a[href='/videos/#{video3.id}']").click
    click_link('+ My Queue')
    expect(page).to have_content video3.title
    expect(page).not_to have_content "Watch Now"




# #clicks title, goes to correct video and there is no '+ My Queue' button
# click_link video1.title
# expect(page).to have_content "Watch Now"
# expect(page).to not_have_content '+ My Queue'

# #adds two more videos to queue
# click_video video2 IMPLEMENT
# click_button '+ My Queue'
# expect(page).to have_content "List Order"
# expect(page).to have_content video2.title

# #update list order
# fill_in 'List Order', with: 5
# expect the order of the list to change around
  end
end


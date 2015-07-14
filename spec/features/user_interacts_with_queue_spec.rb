require 'rails_helper'

  feature "User interacts with the queue" do

    scenario "User adds and reorders videos in the queue" do

    comedy = Fabricate(:category)
    video1 = Fabricate(:video, category: comedy)
    video2 = Fabricate(:video, category: comedy)
    video3 = Fabricate(:video, category: comedy)

    sign_in
    assert_signed_in

    find_and_click(video1)
    assert_show_video_page(video1) 

    queue_video(video1)
    assert_video_queued(video1)

    click_link(video1.title)
    expect(page).not_to have_link '+ My Queue'

    visit home_path
    find_and_click(video2)
    queue_video(video2)

    visit home_path
    find_and_click(video3)
    queue_video(video3)

    fill_in "video_id_#{video1.id}", with: 3
    fill_in "video_id_#{video2.id}", with: 1
    fill_in "video_id_#{video3.id}", with: 2

    click_button 'Update Instant Queue'
    expect(find("#video_id_#{video1.id}").value).to eq("3")
    expect(find("#video_id_#{video2.id}").value).to eq("1")
    expect(find("#video_id_#{video3.id}").value).to eq("2")
    






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

  def assert_signed_in
    expect(page).to have_content User.first.name
  end

  def assert_show_video_page(video)
    expect(page).to have_content video.title
  end

  def find_and_click(video)
    find("a[href='/videos/#{video.id}']").click
  end

  def queue_video(video)
    click_link '+ My Queue'
  end

  def assert_video_queued(video)
    expect(page).to have_content video.title
    expect(page).not_to have_content "Watch Now"
  end
end


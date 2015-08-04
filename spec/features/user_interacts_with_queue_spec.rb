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
    assert_link_gone('+ My Queue')

    visit home_path
    find_and_click(video2)
    queue_video(video2)

    visit home_path
    find_and_click(video3)
    queue_video(video3)

    set_video_position(video1, 3)
    set_video_position(video2, 1)
    set_video_position(video3, 2)

    update_queue

    expect_video_position(video1, 3)
    expect_video_position(video2, 1)
    expect_video_position(video3, 2)
    
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

  def assert_link_gone(link)
    expect(page).to have_no_link link
  end

  def queue_video(video)
    click_link '+ My Queue'
  end

  def assert_video_queued(video)
    expect(page).to have_content video.title
    expect(page).to have_no_content "Watch Now"
  end

  def set_video_position(video, position)
    fill_in "video_id_#{video.id}", with: position
  end

  def update_queue
    click_button 'Update Instant Queue'
  end

  def expect_video_position(video, position)
    expect(find("#video_id_#{video.id}").value).to eq("#{position}")
  end
end


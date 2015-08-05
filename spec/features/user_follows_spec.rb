require 'rails_helper'

feature "User follows another user" do
  scenario "User follows and unfollows another user" do
    leader = Fabricate(:user)
    comedy = Fabricate(:category)
    video = Fabricate(:video, category: comedy)
    review = Fabricate(:review, rating: 5, body: "Great movie", video: video, user: leader)

    sign_in
    click_video(video)
    assert_show_video_page(video)

    click_link leader.name
    assert_user_page(leader)

    click_link("Follow")  
    assert_people_page
    assert_following(leader)

    unfollow_user(leader)
    assert_not_following(leader)
  end

  def click_video(video)
    find("a[href='/videos/#{video.id}']").click
  end

  def assert_show_video_page(video)
    expect(page).to have_content video.title
  end

  def assert_user_page(user)
    expect(page).to have_content "#{user.name}'s video collections"
  end

  def assert_people_page
    expect(page).to have_content "People I Follow"
  end

  def assert_following(user)
    expect(page).to have_content user.name
  end

  def unfollow_user(user)
    find("a[href='/relationships/#{Relationship.first.id}']").click
  end

  def assert_not_following(user)
    expect(page).to have_no_content user.name
    expect(page).to have_content "You are no longer following that user"
  end
end
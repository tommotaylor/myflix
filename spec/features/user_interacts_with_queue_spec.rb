require 'rails_helper'

feature "User interacts with the queue" do

  scenario "user adds and reorders videos" do
    Fabricate(:user, email: 'tom@tom.com', password: 'password')
    visit sign_in_path
    fill_in 'Email', with: 'tom@tom.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'
    expect(page).to have_content User.first.name

    #clicks video on home page and goes to video page
    video1 = Fabricate(:video)
    video2 = Fabricate(:video)
    video3 = Fabricate(:video)
    click_video video1 IMPLEMENT
    expect(page).to have_content video1.title
    expect(page).to have_content "Watch Now"

    #adds video to queue and sees it in the queue
    click_button '+ My Queue'
    expect(page).to have_content "List Order"
    expect(page).to have_content video1.title

    #clicks title, goes to correct video and there is no '+ My Queue' button
    click_link video1.title
    expect(page).to have_content "Watch Now"
    expect(page).to not_have_content '+ My Queue'

    #adds two more videos to queue
    click_video video2 IMPLEMENT
    click_button '+ My Queue'
    expect(page).to have_content "List Order"
    expect(page).to have_content video2.title

    #update list order
    fill_in 'List Order', with: 5
    expect the order of the list to change around

  end

end

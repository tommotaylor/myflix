require 'rails_helper'

feature 'Invite a friend to join MyFlix' do
  scenario 'user sends invitation to friend' do

    clear_emails

    sign_in
    visit new_invite_path
    fill_in "Friend's Name", with: "Mr Friend"
    fill_in "Friend's Email Address", with: "friend@friend.com"
    click_button "Send Invitation"

    open_email("friend@friend.com")
    expect(current_email).to have_content("You have been invited to join MyFlix")

    current_email.click_link("Sign up here")
    expect(page).to have_xpath("//input[@value='friend@friend.com']")

    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Mr Friend"
    click_button "Sign Up"

    click_link "People"
    expect(page).to have_content('Tom Taylor')
  
  end
end
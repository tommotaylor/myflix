require 'rails_helper'

feature 'Invite a friend to join MyFlix' do
  scenario 'user sends invitation to friend' do

    clear_emails
    @user = Fabricate(:user)
    
    invite_friend
    friend_signs_up_from_invite
    
    friend_should_follow_user
    user_should_follow_friend

    clear_emails
  end

  def invite_friend
    sign_in(@user)
    visit new_invite_path
    fill_in "Friend's Name", with: "Mr Friend"
    fill_in "Friend's Email Address", with: "friend@friend.com"
    click_button "Send Invitation"
    sign_out
  end

  def friend_signs_up_from_invite
    open_email("friend@friend.com")
    expect(current_email).to have_content("You have been invited to join MyFlix")
    current_email.click_link("Sign up here")
    expect(page).to have_xpath("//input[@value='friend@friend.com']")
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Mr Friend"
    click_button "Sign Up"
  end

  def friend_should_follow_user
    click_link "People"
    expect(page).to have_content(@user.name)
    sign_out
  end

  def user_should_follow_friend
    sign_in(@user)
    click_link("People")
    expect(page).to have_content('Mr Friend')
  end
end
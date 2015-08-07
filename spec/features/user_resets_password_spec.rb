require 'rails_helper'

feature "user resets password" do
  scenario "user resets password" do
    
    user = Fabricate(:user)
    
    visit sign_in_path
    click_reset_password
    assert_reset_password_page

    enter_and_submit_email(user)
    assert_confirmation_page
  
    follow_reset_link(user)
    update_password("newpassword")

    visit sign_in_path
    enter_new_credentials(user, "newpassword")
    assert_signed_in(user)
  end

  def click_reset_password
    find("a[href='/reset_passwords/new']").click
  end

  def assert_reset_password_page
    expect(page).to have_content("Forgot Password?")
  end

  def enter_and_submit_email(user)
    fill_in "email", with: user.email
    click_button "Send Email"
  end

  def assert_confirmation_page
    expect(page).to have_content("We have sent an email with instruction to reset your password.")
  end

  def follow_reset_link(user)
    visit edit_reset_password_url(user.reload.password_reset_token)
  end

  def update_password(new_password)
    fill_in "user_password", with: new_password
    click_button "Reset Password"
  end

  def enter_new_credentials(user, password)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Sign In'
  end

  def assert_signed_in(user)
    expect(page).to have_content user.name
  end

end
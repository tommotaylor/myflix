require 'rails_helper'

feature "user resets password" do
  scenario "user successfully resets password" do
    
    user = Fabricate(:user, password: "oldpassword")
    clear_emails

    visit sign_in_path
    click_link "Forgot your password?"

    enter_and_submit_email(user)
    expect(page).to have_content("We have sent an email with instruction to reset your password.")
  
    open_email(user.email)
    expect(current_email).to have_content("Here is your reset password link")

    current_email.click_link("password reset link")
    update_password("newpassword")

    enter_new_credentials(user, "newpassword")
    expect(page).to have_content user.name
  end

  def enter_and_submit_email(user)
    fill_in "email", with: user.email
    click_button "Send Email"
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
end
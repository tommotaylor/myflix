require 'rails_helper'

feature "View recent payments page" do
  
  scenario "Admin views recent payments page" do
    user = Fabricate(:user)
    payment = Fabricate(:payment, user: user, reference_id: "12345")

    admin_sign_in
    visit admin_payments_path
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to have_content("£9.99")
    expect(page).to have_content("12345")
  end
  
  scenario "User tries to view recent payments page" do
    sign_in
    visit admin_payments_path
    expect(page).to have_content("You cannot access that area")    
  end
end
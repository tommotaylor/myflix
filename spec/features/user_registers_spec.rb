require 'rails_helper'

feature 'User registers' do
  scenario 'User registers without invite' do
    visit register_path
    fill_in "Email Address", with: "tom@tom.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Tom Taylor"
    click_button "Sign Up"
    expect(page).to have_content("Welcome, Tom Taylor")
  end
end
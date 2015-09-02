require 'rails_helper'

feature 'User registers' do
  scenario 'User registers without invite', { js: true, vcr: true } do
    visit register_path
    fill_in "Email Address", with: "tom@tom.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Tom Taylor"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "1 - January", from: "date_month"
    select "2017", from: "date_year"
    click_button "Sign Up"
    expect(page).to have_content("Welcome, Tom Taylor")
  end
end
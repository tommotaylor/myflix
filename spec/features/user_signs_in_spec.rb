require 'rails_helper'
require 'pry'
require 'pry-nav'

feature "User signs in" do
  background do
    Fabricate(:user, email: 'tom@tom.com', password: 'password')
  end

  scenario "with correct credentials" do
    visit sign_in_path
    fill_in 'Email', with: 'tom@tom.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'
    expect(page).to have_content User.first.name
  end

  scenario "with incorrect credentials" do
    visit sign_in_path
    fill_in 'Email', with: "bob@bob.com"
    fill_in 'Password', with: "password"
    click_button 'Sign In'
    expect(page).to have_content 'There is something wrong with your username or password'
  end

  scenario "with deactivated account" do
    user = Fabricate(:user, email: 'inactive@inactive.com', password: 'password', account_status: false)
    visit sign_in_path
    fill_in 'Email', with: 'inactive@inactive.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'
    expect(page).to_not have_content User.first.name
    expect(page).to have_content("Your account has been deactivated as we couldn't charge your card, please contact customer services")
  end
end
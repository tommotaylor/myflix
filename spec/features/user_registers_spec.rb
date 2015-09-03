require 'rails_helper'

feature 'User registers without invite', { js: true, vcr: true} do
  
  scenario 'with valid user and card info' do
    visit register_path
    fill_in "Email Address", with: "tom@tom.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Tom Taylor"
    completes_credit_card_fields(card_number: '4242424242424242')
    click_button "Sign Up"
    expect(page).to have_content("Welcome, Tom Taylor")
  end

  scenario 'with invalid user info but valid card info' do
    visit register_path
    fill_in "Email Address", with: ""
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Tom Taylor"
    completes_credit_card_fields(card_number: '4242424242424242')
    click_button "Sign Up"
    expect(page).to have_content("Please fill out all user fields")
  end
  
  scenario 'with valid user and declined card info' do
    visit register_path
    fill_in "Email Address", with: "tom@tom.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Tom Taylor"
    completes_credit_card_fields(card_number: '4000000000000002')
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined")
  end

  scenario 'with invalid user and invalid card info' do
    visit register_path
    fill_in "Email Address", with: ""
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Tom Taylor"
    completes_credit_card_fields(card_number: '4000000000000002')
    click_button "Sign Up"
    expect(page).to have_content("Please fill out all user fields")
  end

  def completes_credit_card_fields(options={})
    fill_in "Credit Card Number", with: options[:card_number]
    fill_in "Security Code", with: "123"
    select "1 - January", from: "date_month"
    select "2017", from: "date_year"  
  end
end
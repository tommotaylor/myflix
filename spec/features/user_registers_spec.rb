require 'rails_helper'

feature 'User registers without invite', { js: true, vcr: true} do
  background do
    visit register_path
  end

  scenario 'with valid user and card info' do
    fill_in_user_info(email: "tom@tom.com")
    fill_in_credit_card_info(card_number: '4242424242424242')
    click_button "Sign Up"
    expect(page).to have_content("Welcome, Tom Taylor")
  end

  scenario 'with valid user and declined card info' do
    fill_in_user_info(email: "tom@tom.com")
    fill_in_credit_card_info(card_number: '4000000000000002')
    click_button "Sign Up"
    expect(page).to have_content("Your card was declined")
  end
  
  scenario 'with valid user and invalid card' do
    fill_in_user_info(email: "tom@tom.com")
    fill_in_credit_card_info(card_number: '122')
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end

  scenario 'with invalid user info but valid card info' do
    fill_in_user_info(email: "")
    fill_in_credit_card_info(card_number: '4242424242424242')
    click_button "Sign Up"
    expect(page).to have_content("Please fill out all user fields")
  end
  
  scenario 'with invalid user and invalid card' do
    fill_in_user_info(email: "")
    fill_in_credit_card_info(card_number: '123')
    click_button "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end

  def fill_in_user_info(options={})
    fill_in "Email Address", with: options[:email]
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Tom Taylor"
  end

  def fill_in_credit_card_info(options={})
    fill_in "Credit Card Number", with: options[:card_number]
    fill_in "Security Code", with: "123"
    select "1 - January", from: "date_month"
    select "2017", from: "date_year"  
  end
end
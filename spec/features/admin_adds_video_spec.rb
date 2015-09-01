require 'rails_helper'

feature "Admin adds new video" do
  scenario "Admin successfully uploads a video" do
    documentary = Fabricate(:category, name: "documentary")

    admin_sign_in
    visit new_admin_video_path
    upload_video

    visit sign_out_path
   
    sign_in
    visit video_path(Video.first)
    confirm_image_and_link
  end

  def upload_video
    fill_in "Title", with: "Montage of Heck"
    select "documentary", from: "Category"
    fill_in "Description", with: "Kurt Cobain Documentary"
    attach_file "Large cover", "spec/support/assets/large_cover.jpg"
    attach_file "Small cover", "spec/support/assets/small_cover.jpg"
    fill_in "Video url", with: "www.youtube.com"
    click_button "Add Video"
  end

  def confirm_image_and_link
    expect(page).to have_selector("img[src='/tmp/large_cover.jpg']")    
    expect(page).to have_selector("a[href='www.youtube.com']")    
  end
end
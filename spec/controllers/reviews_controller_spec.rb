require 'rails_helper'

describe ReviewsController  do
  describe "POST create" do
    let(:video) { Fabricate(:video) }

    context "signed in" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      context "with valid inputs" do
        it "creates a review" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.count).to eq(1)
        end
        it "creates a review associated with the video" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.video).to eq(video)
        end
        it "creates a review associated with the user" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(Review.first.user).to eq(user)
        end
        it "redirects to the video show page" do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
          expect(response).to redirect_to video
        end
      end
      context "with invalid inputs" do
        it "does not create the review" do
          post :create, review: {rating: 5}, video_id: video.id
          expect(Review.count).to eq(0)
        end
        it "renders video/show page" do
          post :create, review: {rating: 5}, video_id: video.id
          expect(response).to render_template 'videos/show'
        end
      end
    end
    context "not signed in" do
      it "redirects to sign in page" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
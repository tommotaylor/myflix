require 'rails_helper'

describe QueueItemsController do

  describe "GET index" do
    before do
      session[:user_id] = Fabricate(:user).id
    end
    it "renders the index page" do
      get :index
      expect(response).to render_template(:index)
    end
    it "sets the @queue_items variable" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_items = Fabricate(:queue_item, video_id: video, user_id: user)
      get :index
      expect(assigns(:queue_items)).to eq([queue_items])
    end
  end

  describe "POST create" do
    context "signed in" do 
      before do
        session[:user_id] = Fabricate(:user).id
      end
      context "with valid inputs" do
        it "creates a queue item" do
          post :create, queue_item: Fabricate.attributes_for(:queue_item)
          expect(Review.count).to eq(1)
        end
        it "creates a queue item with the current_user"
        it "creates a queue item with the current video"
        it "redirects to my_queue"
      end
      context "with invalid inputs" do
        it "does not create a queue item"
        it "it renders the video#show page"
      end
    end
    context "not signed in" do
      it "redirects to the sign in page"
    end
  end
end
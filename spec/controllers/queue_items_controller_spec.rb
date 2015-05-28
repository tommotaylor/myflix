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
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.count).to eq(1)
        end
        it "creates a queue item with the current_user" do
          video = Fabricate(:video)
          post :create, video_id: video.id, user_id: session[:user_id]
          expect(QueueItem.first.user_id).to eq(session[:user_id])
        end
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
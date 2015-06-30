require 'rails_helper'

describe QueueItemsController do

  describe "GET index" do
    it "redirects to the sign in page for unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
    it "renders the index page" do
      session[:user_id] = Fabricate(:user).id
      get :index
      expect(response).to render_template(:index)
    end
    it "sets the @queue_items variable" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      queue_items = Fabricate(:queue_item, video_id: video.id, user_id: session[:user_id])
      get :index
      expect(assigns(:queue_items)).to eq([queue_items])
    end
  end

  describe "POST create" do
    context "signed in" do 
      before do
        session[:user_id] = Fabricate(:user).id
      end
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
      it "creates a queue item with the current video" do
        video = Fabricate(:video)
        post :create, video_id: video, user_id: session[:user_id]
        expect(QueueItem.first.video).to eq(video)
      end
      it "redirects to my_queue" do
        video = Fabricate(:video)
        post :create, video_id: video, user_id: session[:user_id]
        expect(response).to redirect_to my_queue_path
      end
      it "adds the new queue item as the last in the queue" do
        video = Fabricate(:video)
        first_queue_item = Fabricate(:queue_item, video_id: video.id, user_id: session[:user_id])
        mad_max = Fabricate(:video)
        post :create, video_id: mad_max, user_id: session[:user_id]
        mad_max_queue_item = QueueItem.where(video_id: mad_max.id)
        expect(QueueItem.last.video).to eq(mad_max)
      end
      it "does not add the video to the queue if it is already in the queue" do
        video = Fabricate(:video)
        first_queue_item = Fabricate(:queue_item, video_id: video.id, user_id: session[:user_id])
        post :create, video_id: video, user_id: session[:user_id]
        expect(QueueItem.count).to eq(1)
      end
    end
    context "not signed in" do
      it "redirects to the sign in page" do
        video = Fabricate(:video)
        post :create, video_id: video, user_id: session[:user_id]
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end
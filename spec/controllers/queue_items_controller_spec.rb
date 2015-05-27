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
  
end
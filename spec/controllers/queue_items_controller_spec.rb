require 'rails_helper'
require 'pry'
require 'pry-nav'

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
        video_one = Fabricate(:video, title: "Video One")
        video_two = Fabricate(:video, title: "Video Two")
        first_queue_item = Fabricate(:queue_item, video_id: video_one.id, user_id: session[:user_id], list_order: 1)
        post :create, video_id: video_two.id, user_id: session[:user_id]
        expect(QueueItem.second.list_order).to eq(2)
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

  describe "POST delete" do
    before do
      session[:user_id] = Fabricate(:user).id
    end
    it "redirects to my_queue" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: session[:user_id])
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end
    it "deletes the queue item" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: session[:user_id])
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end
    it "does not delete the queue item if doesn't belong to the user" do
      video = Fabricate(:video)
      other_user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: other_user.id)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end
    it "redirects unauthenticated user to sign in" do
      session[:user_id] = nil
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to sign_in_path
    end
    it "normalises the queue after delete" do
      queue_item1 = Fabricate(:queue_item, user_id: session[:user_id], list_order: 1)
      queue_item2 = Fabricate(:queue_item, user_id: session[:user_id], list_order: 2)
      queue_item3 = Fabricate(:queue_item, user_id: session[:user_id], list_order: 3)
      delete :destroy, id: queue_item2.id
      expect(queue_item3.reload.list_order).to eq(2)
    end
  end

  describe "POST update_list_order" do
    context "with valid inputs" do

      let(:video1) {Fabricate(:video)}
      let(:video2) {Fabricate(:video)}
      let(:queue_item_one) {Fabricate(:queue_item, user_id: session[:user_id], list_order: 1, video_id: video1.id)}
      let(:queue_item_two) {Fabricate(:queue_item, user_id: session[:user_id], list_order: 2, video_id: video2.id)}

      before do
        session[:user_id] = Fabricate(:user).id
      end

      it "redirects to my_queue" do
        post :update_queue_items, queue_items: [{id: queue_item_one.id, "list_order"=>"2"}, {id: queue_item_two.id, "list_order"=>"1"}]
        expect(response).to redirect_to my_queue_path
      end
      it "saves the queue items' new list_order" do
        post :update_queue_items, queue_items: [{id: queue_item_one.id, list_order: 2}, {id: queue_item_two.id, list_order: 1}]
        expect(queue_item_one.reload.list_order).to eq(2)
      end
      it "normalises the list_order" do
        post :update_queue_items, queue_items: [{id: queue_item_one.id, list_order: 5}, {id: queue_item_two.id, list_order: 4}]
        expect(queue_item_one.reload.list_order).to eq(2)
      end
      it "updates the rating of the user" do
        review = Fabricate(:review, video_id: video1.id, user_id: session[:user_id], rating: 1)
        post :update_queue_items, queue_items: [{id: queue_item_one.id, list_order: 1, rating: 5}]
        expect(review.reload.rating).to eq(5)
      end
      it "creates a new rating if none exists" do
        post :update_queue_items, queue_items: [{id: queue_item_one.id, list_order: 1, rating: 5}]
        expect(queue_item_one.reload.rating).to eq(5)
      end
      
    end
    context "with invalid inputs" do

      let(:video1) {Fabricate(:video)}
      let(:video2) {Fabricate(:video)}
      let(:queue_item_one) {Fabricate(:queue_item, user_id: session[:user_id], list_order: 1, video_id: video1.id)}
      let(:queue_item_two) {Fabricate(:queue_item, user_id: session[:user_id], list_order: 2, video_id: video2.id)}

      before do
        session[:user_id] = Fabricate(:user).id
      end

      it "doesn't update the list order if the data is a string" do
        post :update_queue_items, queue_items: [{id: queue_item_one.id, list_order: 3}, {id: queue_item_two.id, list_order: "foobar"}]
        expect(queue_item_one.reload.list_order).to eq(1)
      end
      it "doesn't update the list order if the data is a float" do
        post :update_queue_items, queue_items: [{id: queue_item_one.id, list_order: 3.5}, {id: queue_item_two.id, list_order: 2}]
        expect(queue_item_one.reload.list_order).to eq(1)
      end
      it "flashes an error" do
        post :update_queue_items, queue_items: [{id: queue_item_one.id, list_order: 3.5}, {id: queue_item_two.id, list_order: 2}]
        expect(flash[:error]).to be_present
      end
      it "doesn't save the rating" do
        alice = User.find(session[:user_id])
        review1 = Fabricate(:review, video_id: video1.id, user_id: session[:user_id], rating: 4)
        review2 = Fabricate(:review, video_id: video2.id, user_id: session[:user_id], rating: 5)
        post :update_queue_items, queue_items: [{id: queue_item_one.id, list_order: 1, rating: 6}, {id: queue_item_two.id, list_order: 2, rating: "foobar"}]
        expect(alice.queue_items.map(&:rating)).to eq([4, 5])
      end
    end
    context "with unauthenticated users" do
      it "redirects to the sign in page" do
        queue_item_one = Fabricate(:queue_item, user_id: session[:user_id], list_order: 1)
        queue_item_two = Fabricate(:queue_item, user_id: session[:user_id], list_order: 2)
        post :update_queue_items, queue_items: [{id: queue_item_one.id, "list_order"=>"2"}, {id: queue_item_two.id, "list_order"=>"1"}]
        expect(response).to redirect_to sign_in_path
      end
    end
    context "with queue items that are not in the users queue" do
      it "doesn't update the list order" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user1.id
        queue_item_one = Fabricate(:queue_item, user_id: user1.id, list_order: 1)
        queue_item_two = Fabricate(:queue_item, user_id: user1.id, list_order: 2)
        queue_item_three = Fabricate(:queue_item, user_id: user2.id, list_order: 1)
        queue_item_four = Fabricate(:queue_item, user_id: user2.id, list_order: 2)
        post :update_queue_items, queue_items: [{id: queue_item_three.id, list_order: 2}, {id: queue_item_four.id, list_order: 1}]
        expect(queue_item_four.reload.list_order).to eq(2)
      end
      it "doesn't update the rating" do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user1.id
        video = Fabricate(:video)
        review = Fabricate(:review, video_id: video.id, user_id: user2.id, rating: 5)
        queue_item = Fabricate(:queue_item, user_id: user2.id, video_id: video.id, list_order: 1)
        post :update_queue_items, rating: [{id: queue_item.id, rating: 1}], queue_items: [{id: queue_item.id, list_order: 1}]
        expect(queue_item.reload.rating).to eq(5)
      end
    end
  end
end
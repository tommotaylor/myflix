require 'rails_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets the @relationships variable to the current users following relationships" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it "redirects to people page" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to(people_path)
    end
    it "deletes the correct relationship object" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end
    it "does not delete the relationship object if the follower is not the current user" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      user3 = Fabricate(:user)
      set_current_user(user3)
      relationship = Fabricate(:relationship, follower: user1, leader: user2)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
    it_behaves_like "requires sign in" do
      let(:action) {delete :destroy, id: 1}
    end
  end

  describe "POST create" do
    it "redirects to people page" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user2.id
      expect(response).to redirect_to people_path
    end
    it "creates the relationship with the current user and associated leader" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user2.id
      expect(Relationship.first.leader).to eq(user2)
      expect(Relationship.first.follower).to eq(user1)
    end
    it "does not create the relationship if the user is already being followed by the current user" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      set_current_user(user1)
      Relationship.create(follower_id: user1.id, leader_id: user2.id)
      post :create, leader_id: user2.id
      expect(Relationship.count).to eq(1)
    end
    it "does not allow one to follow oneself" do
      user1 = Fabricate(:user)
      set_current_user(user1)
      post :create, leader_id: user1.id
      expect(Relationship.count).to eq(0)      
    end
  end
end
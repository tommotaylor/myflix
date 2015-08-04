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
    it "redirects to my_queue" do
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
end
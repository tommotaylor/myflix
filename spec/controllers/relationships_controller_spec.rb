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
end
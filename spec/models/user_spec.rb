require 'rails_helper'

describe User do
  
  it { should have_many(:queue_items).order(:list_order)}
  it { should have_many(:reviews).order(created_at: :desc)}

  describe "#video_is_queued?" do
    
    it "returns true if the video is in the queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user_id: user.id, video_id: video.id)
      expect(user.video_is_queued?(video)).to be_truthy
    end

    it "returns false if the video isn't in the queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item)
      expect(user.video_is_queued?(video)).to be_falsey
    end
  end

  describe "#can_follow?(other_user)" do
    it "returns false if already following the other user" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      Relationship.create(follower_id: user1.id, leader_id: user2.id)
      expect(user1.can_follow?(user2)).to eq(false)
    end
    it "returns false if other_user is self" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      Relationship.create(follower_id: user1.id, leader_id: user2.id)
      expect(user1.can_follow?(user1)).to eq(false)
    end
    it "returns true if not following and not self" do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      user3 = Fabricate(:user)
      Relationship.create(follower_id: user1.id, leader_id: user2.id)
      expect(user1.can_follow?(user3)).to eq(true)
    end
  end


end

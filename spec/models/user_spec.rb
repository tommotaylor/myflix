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


end

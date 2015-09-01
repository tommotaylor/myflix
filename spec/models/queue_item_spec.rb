require 'rails_helper'

describe QueueItem do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_numericality_of(:list_order).only_integer }

  describe "#category_name" do
    it "returns category name of queue item" do
      drama = Fabricate(:category, name: "drama")
      video = Fabricate(:video, category: drama, title: "Mad Max", description: "something")
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
      expect(queue_item.category_name).to eq(drama.name)
    end
  end

  describe "#category" do
    it "returns the category of the queue item" do
      drama = Fabricate(:category, name: "drama")
      video = Fabricate(:video, category: drama)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
      expect(queue_item.category).to eq(drama)
    end
  end

  describe "#video_title" do
    it "returns the title of the queue items video" do
      category = Fabricate(:category, name: "drama")
      video = Fabricate(:video, category_id: category.id, title: "Dig")
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe "#rating" do
    it "returns the users rating of the video" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user_id: user.id, video_id: video.id, rating: 4)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
      expect(queue_item.rating).to eq(4)
    end
    it "returns nil if there is no rating" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, video_id: video.id, user_id: user.id)
      expect(queue_item.rating).to eq(nil)
    end
  end
end
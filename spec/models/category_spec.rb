require "rails_helper"

describe Category do
  it { should have_many (:videos)}

describe "#recent_videos" do

  it "returns all videos if less than 6 exist, in descending order" do
    documentary = Category.create(name: "documentary")
    black_fish = Video.create(title: "black fish", description: "awesome", category: documentary, created_at: 1.day.ago)
    supermensch = Video.create(title: "supermensch", description: "really awesome", category: documentary)
    expect(documentary.recent_videos).to eq([supermensch, black_fish])
  end

  it "returns 6 videos in descending order if more than 6 exist" do
    documentary = Category.create(name: "documentary")
    7.times { Video.create(title: "supermensch", description: "really awesome", category: documentary) }
    expect(documentary.recent_videos.count).to eq(6)
  end

  it "returns an empty array when there are no matches" do
   documentary = Category.create(name: "documentary")
   expect(documentary.recent_videos).to eq([])
  end

end


end
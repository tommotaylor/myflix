require "rails_helper"

describe Category do
  it { should have_many (:videos)}

describe "#recent_videos" do
 
  it "should return only videos from the named category" do
    sci_fi = Category.create(name: "science fiction")
    documentary = Category.create(name: "documentary")
    interstellar = Video.create(title: "interstellar", description: "awesome", category: sci_fi)
    supermensch = Video.create(title: "supermensch", description: "really awesome", category: documentary)
    expect(documentary.recent_videos).to include(supermensch)
  end

  it "should return all videos if less than 6 exist" do
    documentary = Category.create(name: "documentary")
    black_fish = Video.create(title: "black fish", description: "awesome", category: documentary, created_at: 1.day.ago)
    supermensch = Video.create(title: "supermensch", description: "really awesome", category: documentary)
    expect(documentary.recent_videos).to eq([black_fish, supermensch])
  end

  it "should return 6 videos in descending order if more than 6 exist" do
  end


end


end
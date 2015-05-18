require "rails_helper"

describe Video do
  
  it { should belong_to (:category) }
  it { should validate_presence_of (:title) }
  it { should validate_presence_of (:description) }

  describe "search_by_title" do
    it "returns an empty array when no result" do
      result = Video.search_by_title("")
      expect(result).to eq([])
    end

    it "returns an array with one title when there is an exact match" do
      Video.create(title: "black fish", description: "awesome")
      result = Video.search_by_title("black fish")
      expect(result.length).to eq(1)
    end

    it "returns an array with more than one title when there is more than one match" do
      Video.create(title: "black fish", description: "awesome")
      Video.create(title: "black fish", description: "really awesome")
      result = Video.search_by_title("black fish")
      expect(result.length).to eq(2)
    end

    it "returns an array with two titles when there are two non-exact matches, ordered by newest first" do
      black_fish = Video.create(title: "black fish", description: "awesome", created_at: 1.day.ago)
      blackadder = Video.create(title: "blackadder", description: "really awesome")
      result = Video.search_by_title("black")
      expect(result).to eq([blackadder, black_fish])
    end

    it "returns an empty array when there is an empty search string" do
      Video.create(title: "black fish", description: "awesome")
      Video.create(title: "black fish", description: "really awesome")
      result = Video.search_by_title("")
      expect(result).to eq([])
    end

  end
  

end
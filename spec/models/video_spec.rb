require "rails_helper"

describe Video do
  
  it { should belong_to (:category) }
  it { should validate_presence_of (:title) }
  it { should validate_presence_of (:description) }

  describe "#search_by_title" do
    it "returns an empty array when no result" do
      result = Video.search_by_title("")
      result.should eq([])
    end

    it "returns an array with one title when there is one match" do
      Video.create(title: "black fish", description: "awesome")
      result = Video.search_by_title("black fish")
      result.length.should eq(1)
    end

    it "returns an array with more than one title when there is more than one match" do
      Video.create(title: "black fish", description: "awesome")
      Video.create(title: "black fish", description: "really awesome")
      result = Video.search_by_title("black fish")
      result.length.should eq(2)
    end
  end
  

end
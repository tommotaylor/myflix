require "rails_helper"

describe Video do
  
  it { should belong_to (:category) }
  it { should have_many (:reviews) }
  it { should validate_presence_of (:title) }
  it { should validate_presence_of (:description) }

  describe "search_by_title" do
    it "returns an empty array when no result" do
      result = Video.search_by_title("")
      expect(result).to eq([])
    end
    it "returns an array with one title when there is an exact match" do
      Fabricate(:video, title: "black fish")
      result = Video.search_by_title("black fish")
      expect(result.length).to eq(1)
    end
    it "returns an array with more than one title when there is more than one match" do
      2.times { Fabricate(:video, title: "black fish") }
      result = Video.search_by_title("black fish")
      expect(result.length).to eq(2)
    end
    it "returns an array with two titles when there are two non-exact matches, ordered by newest first" do
      black_fish = Fabricate(:video, title: "black fish", created_at: 1.day.ago)
      blackadder = Fabricate(:video, title: "blackadder")
      result = Video.search_by_title("black")
      expect(result).to eq([blackadder, black_fish])
    end
    it "returns an empty array when there is an empty search string" do
      Fabricate(:video)
      result = Video.search_by_title("")
      expect(result).to eq([])
    end
  end

  describe "average_rating" do
    before do
      @video = Fabricate(:video)
    end
    it "returns an integer equal to the rating of the only review, when only one review" do
      review = Fabricate(:review, video: @video)
      result = @video.average_rating
      expect(result).to eq(review.rating)
    end
    it "returns an integer that is the average of all ratings if more than one review exists" do
      review = Fabricate(:review, video: @video)
      review2 = Fabricate(:review, video: @video)
      result = @video.average_rating
      expect(result).to eq(((review.rating + review2.rating.to_f)/2).round(1))
    end
    it "returns an explanation when there are no reviews" do
      result = @video.average_rating
      expect(result).to eq("No reviews")
    end
  end
end
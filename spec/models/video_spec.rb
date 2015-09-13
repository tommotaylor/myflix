require "rails_helper"

describe Video do
  
  it { should belong_to (:category) }
  it { should have_many (:reviews) }
  it { should validate_presence_of (:title) }
  it { should validate_presence_of (:description) }

  describe "#self.search_by_title" do

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

  describe "#average_rating" do
    let(:video) { Fabricate(:video) }

    it "returns an integer equal to the rating of the only review, when only one review" do
      review = Fabricate(:review, video: video)
      result = video.average_rating
      expect(result).to eq(review.rating)
    end

    it "returns an integer that is the average of all ratings if more than one review exists" do
      review = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      result = video.average_rating
      expect(result).to eq(((review.rating + review2.rating.to_f)/2).round(1))
    end

    it "returns nil if there are no reviews" do
      result = video.average_rating
      expect(result).to eq(nil)
    end
  end

  describe ".search", :elasticsearch do
    
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index
        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index
        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index
        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index
        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index
        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index
        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end
  end
end
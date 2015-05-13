require "rails_helper"

describe Video do
  it "saves itself" do
    video = Video.new(title: "Fight Club")
    video.save
    Video.first.title.should == "Fight Club"
  end
end
require "rails_helper"

describe Video do
  it "saves itself" do
    video = Video.new(title: "Fight Club")
    video.save
    Video.first.title.should == "Fight Club"
  end

  it "belongs to category" do
    action = Category.create(name: "action")
    die_hard = Video.create(title: "Die Hard", category: action)
    expect(die_hard.category).to eq(action)
  end


end
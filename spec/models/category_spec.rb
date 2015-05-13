require "rails_helper"

describe Category do
  it "saves itself" do
    category = Category.new(name: "comedy")
    category.save
    expect(Category.first).to eq(category)
  end

  it "has many videos" do
    action = Category.create(name: "action")
    die_hard = Video.create(title: "Die Hard", category: action)
    interstellar = Video.create(title: "Interstellar", category: action)
    expect(action.videos).to eq([die_hard, interstellar])
  end

end
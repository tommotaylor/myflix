Fabricator(:review) do
  rating { rand(0..5) }
  body { Faker::Lorem.sentence }
end
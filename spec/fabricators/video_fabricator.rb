Fabricator(:video) do
  title { Faker::Lorem.words(2).join(" ") }
  description { Faker::Lorem.paragraph(1) }
  category { Fabricate(:category) }
end
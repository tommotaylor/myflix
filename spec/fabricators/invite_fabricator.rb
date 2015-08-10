Fabricator(:invite) do
  friend_name { Faker::Name.name }
  friend_email { Faker::Internet.email }
  message { Faker::Lorem.sentence }
end
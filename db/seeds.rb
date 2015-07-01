# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#


Category.create!([ {name: 'drama'}, 
                  {name: 'comedy'}, 
                  {name: 'action'}])

User.create!([
  { name: "Tom Taylor",
    email: "tom@tom.com",
    password: "password"
    },
  { name: "Lucie Watson",
    email: "lucie@lucie.com",
    password: "password"
    },
  { name: "Bob Dylan",
    email: "bob@bob.com",
    password: "password" }])

Video.create!([
  { title: 'Birdman', 
    description: 'A washed-up actor, who once played an iconic superhero, battles his ego and attempts to recover his family, his career and himself in the days leading up to the opening of his Broadway play.',
    small_cover_url: 'tmp/birdman.jpg',
    large_cover_url: '',
    category_id: 1 
    },
  { title: 'Mad Max', 
    description: 'The ultimate desert car chase',
    small_cover_url: 'tmp/birdman.jpg',
    large_cover_url: '',
    category_id: 2 }])

QueueItem.create!([
  { video_id: 1,
    user_id: 1,
    },
  { video_id: 2,
    user_id: 1 }])

Review.create!([
  { rating: 3,
    body: "alright",
    video_id: 1,
    user_id: 1 }])

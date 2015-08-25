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
    password: "password",
    admin: true
    },
  { name: "Lucie Watson",
    email: "lucie@lucie.com",
    password: "password",
    admin: false
    },
  { name: "Bob Dylan",
    email: "bob@bob.com",
    password: "password",
    admin: false }])

Video.create!([
  { title: 'Birdman', 
    description: 'A washed-up actor, who once played an iconic superhero, battles his ego and attempts to recover his family, his career and himself in the days leading up to the opening of his Broadway play.',
    small_cover: 'tmp/birdman.jpg',
    large_cover: 'tmp/large1.jpg',
    category_id: 1 
    },
  { title: 'Family Guy', 
    description: 'The ultimate desert car chase',
    small_cover: 'tmp/family_guy.jpg',
    large_cover: 'tmp/large2.jpg',
    category_id: 2 
    },
  { title: 'Chinatown', 
    description: 'A classic about all things that make mans life valuable',
    small_cover: 'tmp/chinatown.jpg',
    large_cover: 'tmp/large3.jpg',
    category_id: 1 
    },
  { title: 'Eddie Murphy: Delirious', 
    description: 'Stand up classic from Eddie Murphy',
    small_cover: 'tmp/eddie_murphy.jpg',
    large_cover: 'tmp/large4.jpg',
    category_id: 2 
    },
  { title: 'Platoon', 
    description: 'A Vietnam War Epic',
    small_cover: 'tmp/platoon.jpg',
    large_cover: 'tmp/large1.jpg',
    category_id: 3 
    },
  { title: 'Loruz', 
    description: 'Cult Indie Foreign Nonsense',
    small_cover: 'tmp/loruz.jpg',
    large_cover: 'tmp/large2.jpg',
    category_id: 1 
    },
  { title: 'Frank', 
    description: 'The rise and demise of an indie band on their way to SXSW',
    small_cover: 'tmp/frank.jpg',
    large_cover: 'tmp/large3.jpg',
    category_id: 1 
    },
  { title: 'Futurama', 
    description: 'From the makers of The Simpsons',
    small_cover: 'tmp/futurama.jpg',
    large_cover: 'tmp/large4.jpg',
    category_id: 2 }])

QueueItem.create!([
  { video_id: 1,
    user_id: 1,
    list_order: 1
    },
  { video_id: 2,
    user_id: 1,
    list_order: 2 }])

Review.create!([
  { rating: 3,
    body: "alright",
    video_id: 1,
    user_id: 1 }])

Relationship.create!([
  { follower_id: 1,
    leader_id: 2
    },
  { follower_id: 1,
    leader_id: 3 }])

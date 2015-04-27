# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
  videos = Video.create([
    { title: 'Birdman', 
      description: 'A washed-up actor, who once played an iconic superhero, battles his ego and attempts to recover his family, his career and himself in the days leading up to the opening of his Broadway play.',
      small_cover_url: 'public/tmp/birdman.jpg',
      large_cover_url: '' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

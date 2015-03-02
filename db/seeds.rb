# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cat_comedy = Category.create(title: 'TV Comedies')
cat_drama = Category.create(title: 'TV Dramas')
cat_reality = Category.create(title: 'Reality TV')

v = cat_comedy.videos.build(title: 'South Park', description: 'funny cartoon', small_cover_url: '/tmp/south_park.jpg', large_cover_url: '/tmp/monk_large.jpg')
v.save

v = cat_drama.videos.build(title: 'Monk', description: 'Monk is... monk.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg')
v.save

v = cat_reality.videos.build(title: 'Reality Monk', description: 'Monk is still a monk.', small_cover_url: 'tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg')
v.save
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

cat_comedy = Category.create(title: 'TV Comedies', description: 'tv comedies')
cat_drama = Category.create(title: 'TV Dramas', description: 'tv dramas')
cat_reality = Category.create(title: 'Reality TV', description: 'reality tv')

admin = User.create(email: 'admin@admin.com', full_name: 'admin', password: 'aaa', admin: true)
bob = User.create(email: 'bob@bob.com', full_name: 'bob', password: 'bbb')

Fabricate(:user)

Relationship.create(leader: bob, follower: admin)

10.times do |index|
  v = cat_comedy.videos.create(title: "South Park - #{index}", description: 'funny cartoon', small_cover: '/tmp/south_park.jpg', large_cover: '/tmp/monk_large.jpg', video_url: 'http://d1b1wr57ag5rdp.cloudfront.net/uploads/joinme.mp4')
  Fabricate(:review, user: bob, video: v)
end

10.times do |index|
  v = cat_drama.videos.create(title: "Monk - #{index}", description: 'Monk is... monk.', small_cover: '/tmp/monk.jpg', large_cover: '/tmp/monk_large.jpg', video_url: 'http://d1b1wr57ag5rdp.cloudfront.net/uploads/joinme.mp4')
end

10.times do |index|
  v = cat_reality.videos.create(title: "Reality - #{index}", description: 'Monk is still a monk.', small_cover: '/tmp/monk.jpg', large_cover: '/tmp/monk_large.jpg', video_url: 'http://d1b1wr57ag5rdp.cloudfront.net/uploads/joinme.mp4')
end

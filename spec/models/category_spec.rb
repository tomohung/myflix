require 'spec_helper'

describe Category do
  it { should have_many(:videos)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}


  describe '#recent_videos' do
    
    let(:cat) { Fabricate(:category) }

    it 'creates 10 videos' do 
      10.times do |index|
        video = Video.create(title: "video#{index}", description: "video index = #{index}", category: cat, created_at: index.day.ago)
      end
      expect(Video.count).to eq(10)
    end

    it 'returns recent 6 videos' do
      (1..10).each do |index|
        video = cat.videos.new(title: "video#{index}", description: "description to #{index}", created_at: index.days.ago)
        video.save
      end

      expect(cat.recent_videos.size).to eq(Category::RECENT_VIDEOS_COUNT)
    end

    it 'returns all videos if videos less than 6' do
      (1..4).each do |index|
        video = cat.videos.new(title: "video#{index}", description: "description to #{index}", created_at: index.days.ago)
        video.save
      end

      expect(cat.recent_videos.size).to eq(4)
    end

    it 'returns by ordered DESC' do
      hero = Video.create(title: 'hero', description: 'hero action movie', category: cat, created_at: 1.day.ago)
      keroro = Video.create(title: 'keroro', description: 'cartoon', category: cat)
      expect(cat.recent_videos).to eq([keroro, hero])
    end

    it 'return lastest 6 videos' do
      (1..Category::RECENT_VIDEOS_COUNT).each do |index|
        video = cat.videos.new(title: "video#{index}", description: "description to #{index}")
        video.save
      end
      old_video = Video.create(title: 'old movie', description: "there's an old movie", created_at: 1.day.ago)
      expect(cat.recent_videos).not_to include(old_video)
    end

    it 'returns empty array if category has no video' do
      expect(cat.recent_videos).to eq([])
    end
  end
end

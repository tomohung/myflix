require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :user }
  it { should validate_presence_of :video }

  describe '#video_title' do
    it 'returns title of associated video' do
      user = Fabricate(:user)
      category = Fabricate(:category)
      video = Fabricate(:video, title: 'video', category: category)
      queue_item = QueueItem.create(user: user, video: video)
      expect(queue_item.video_title).to eq('video')
    end
  end

  describe '#rating' do
    it 'returns rating from the review if review is present' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, user: user, video: video, rating: 4)
      queue_item = QueueItem.create(user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end

    it 'returns nil if review is not present' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = QueueItem.create(user: user, video: video)
      expect(queue_item.rating).to be_nil
    end

  end

  describe '#category_name' do
    it 'returns category name of video' do
      user = Fabricate(:user)
      category = Fabricate(:category, title: 'TV')
      video = Fabricate(:video, category: category)
      queue_item = QueueItem.create(user: user, video: video)
      expect(queue_item.category_name).to eq('TV')      
    end
  end

  describe '#category' do
    it 'returns category of video' do
      user = Fabricate(:user)
      category = Fabricate(:category)
      video = Fabricate(:video, title: 'video', category: category)
      queue_item = QueueItem.create(user: user, video: video)
      expect(queue_item.category).to eq(category)      
    end
  end


end

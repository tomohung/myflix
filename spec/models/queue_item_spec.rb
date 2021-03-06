require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_presence_of :user }
  it { should validate_presence_of :video }
  it { should validate_numericality_of(:position).only_integer  }

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
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it 'returns rating from the review if review is present' do
      review = Fabricate(:review, user: user, video: video, rating: 4)
      queue_item = QueueItem.create(user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end

    it 'returns nil if review is not present' do
      queue_item = QueueItem.create(user: user, video: video)
      expect(queue_item.rating).to be_nil
    end
  end

  describe '#rating=' do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }

    it 'changes rating of the review if review is present' do
      review = Fabricate(:review, user: user, video: video, rating: 5)
      queue_item.rating = 3
      expect(review.reload.rating).to eq(3)
    end

    it 'clears the rating of the review if review is present' do
      review = Fabricate(:review, user: user, video: video, rating: 5)
      queue_item.rating = nil
      expect(review.reload.rating).to be_nil
    end
    
    it 'creates a review with the rating if review is not preset' do
      expect { queue_item.rating = 3 }.to change { Review.count }.by 1
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

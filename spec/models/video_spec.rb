require 'spec_helper'

describe Video do

  it { should belong_to(:category)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}

  describe 'search_by_title' do
    it 'returns an empty array if no match' do
      hero = Video.create(title: 'Hero', description: 'Superman', created_at: 1.day.ago)
      keroro = Video.create(title: 'Keror', description: 'Cartoon')

      expect(Video.search_by_title('hero')).to eq([])
    end

    it 'returns an array of one video' do
      hero = Video.create(title: 'Hero', description: 'Superman', created_at: 1.day.ago)
      keroro = Video.create(title: 'Keror', description: 'Cartoon')
      expect(Video.search_by_title('Hero')).to eq([hero])
    end

    it 'returns an array if partial match' do
      hero = Video.create(title: 'Hero', description: 'Superman', created_at: 1.day.ago)
      keroro = Video.create(title: 'Keror', description: 'Cartoon')
      expect(Video.search_by_title('Her')).to eq([hero])
    end
    
    it 'returns an array of all matches ordered by created_at' do
      hero = Video.create(title: 'Hero', description: 'Superman', created_at: 1.day.ago)
      keroro = Video.create(title: 'Keror', description: 'Cartoon', created_at: 5.minute.ago)
      expect(Video.search_by_title('ero')).to eq([keroro, hero])
    end

    it 'return an empty array if search_term is blank' do
      hero = Video.create(title: 'Hero', description: 'Superman', created_at: 1.day.ago)
      keroro = Video.create(title: 'Keror', description: 'Cartoon', created_at: 4.minute.ago)
      expect(Video.search_by_title('')).to eq([])
    end
  end 
end

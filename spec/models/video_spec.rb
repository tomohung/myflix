require 'spec_helper'

describe Video do

  it 'save itself' do 
    video = Video.new(title: 'kochikame', description: 'the best cartoon ever')
    video.save
    Video.first.title.should == 'kochikame'
  end

  it 'RSpec favorite way' do 
    video = Video.new(title: 'try again', description: 'why do you try again')
    video.save
    expect(Video.first).to eq(video)
  end

  it 'belongs_to category' do 
    tv = Category.create(title: 'TV')
    kochikame = Video.create(title: 'Kochikame', category: tv)

    expect(kochikame.category).to eq(tv)
  end

  it 'validates title' do
    video = Video.create(description: 'just video')
    expect(Video.count).to eq(0)
  end

  it 'validates desciption' do
    video = Video.create(title: 'Video')
    expect(Video.count).to eq(0)
  end

end
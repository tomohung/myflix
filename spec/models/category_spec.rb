require 'spec_helper'

describe Category do
  it 'save itself' do
    tv = Category.create(title: 'TV', description: 'just tv')
    expect(Category.first).to eq(tv)
  end

  it 'has many videos' do
    tv = Category.create(title: 'TV', description: 'just tv')
    kochikame = Video.create(title: 'kochikame', description: 'cartoon', category: tv)
    monk = Video.create(title: 'Monk', description: 'cartoon', category: tv)

    expect(tv.videos).to eq([kochikame, monk])
  end

  it 'validates title' do
    tv = Category.create(description: 'only description')
    expect(Category.count).to eq(0)
  end

  it 'validates description' do
    tv = Category.create(title: 'TV')
    expect(Category.count).to eq(0)
  end
end
require 'spec_helper'

describe User do 

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email) }
  
  describe '#follows?' do
    it 'returns true if user has a following relationship with another user' do
      bob = Fabricate(:user)
      amy = Fabricate(:user)
      Relationship.create(follower: bob, leader: amy)
      expect(bob.follows?(amy)).to be true
    end

    it 'returns false if user does not have a following relationship with another user' do
      bob = Fabricate(:user)
      amy = Fabricate(:user)
      expect(bob.follows?(amy)).to be false
    end
  end

  describe '#generate_token' do
    it 'generates a random token when user is created' do
      user = Fabricate(:user)
      expect(User.first.token).to be_present
    end
  end

end

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

  describe '#follow' do
    it 'follows another user' do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      user1.follow(user2)
      expect(user1.reload.follows?(user2.reload)).to be true
    end

    it 'does not follow one self' do
      user1 = Fabricate(:user)
      user2 = Fabricate(:user)
      Relationship.create(follower: user1, leader: user2)
      user1.follow(user2)
      expect(Relationship.count).to eq(1)
    end
  end

  describe '#deactivate!' do
    it 'deactivates an active user' do
      user = Fabricate(:user, active: true)
      user.deactivate!
      expect(user).not_to be_active
    end
  end

end

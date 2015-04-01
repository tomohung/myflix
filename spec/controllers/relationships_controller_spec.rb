require 'spec_helper'

describe RelationshipsController do
  describe 'GET index' do
    it "sets @relationships to the current user's following relationships" do
      bob = Fabricate(:user)
      set_current_user(bob)
      nancy = Fabricate(:user)
      relation = Fabricate(:relationship, leader: nancy, follower: bob)
      get :index
      expect(assigns(:relationships)).to eq([relation])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe 'DELETE destroy' do
    it_behaves_like 'require_sign_in' do
      let(:action) { delete :destroy, id: 1 }
    end

    it 'deletes the relationship if current user is the follower' do
      bob = Fabricate(:user)
      set_current_user(bob)
      amy = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: amy)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it 'redirects to the people page' do
      bob = Fabricate(:user)
      set_current_user(bob)
      amy = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: amy)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end
    
    it 'does not delete the relationship if current user is not the follower' do
      bob = Fabricate(:user)
      set_current_user(bob)
      amy = Fabricate(:user)
      chris = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: chris, leader: amy)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)      
    end
  end

  describe 'POST create' do
    it_behaves_like 'require_sign_in' do
      let(:action) { post :create, leader_id: 3}
    end
    
    it 'redirects to people page' do
      bob = Fabricate(:user)
      amy = Fabricate(:user)
      set_current_user(bob)
      post :create, leader_id: amy.id
      expect(response).to redirect_to people_path
    end

    it 'creates a relationship that current user follows leader' do
      bob = Fabricate(:user)
      amy = Fabricate(:user)
      set_current_user(bob)
      post :create, leader_id: amy.id
      expect(bob.following_relationships.first.leader).to eq(amy)      
    end
    
    it 'does not create a relationship if current user already follows the leader' do
      bob = Fabricate(:user)
      amy = Fabricate(:user)
      set_current_user(bob)
      Fabricate(:relationship, follower: bob, leader: amy)
      post :create, leader_id: amy.id
      expect(Relationship.count).to eq(1)
    end
    
    it 'does not allow one to follow themselves' do
      bob = Fabricate(:user)
      set_current_user(bob)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(0)
    end    
  end

end

require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it 'sets @queue_items with authentication' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      @queue_items = user.queue_items
      get :index
      expect(assigns(:queue_items)).to match_array(@queue_items)
    end

    it 'redirect_to sign in page with unquthentication' do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

end

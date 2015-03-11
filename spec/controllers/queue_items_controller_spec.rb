require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it 'sets @queue_items with authentication' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_items = user.queue_items
      get :index
      expect(assigns(:queue_items)).to match_array(queue_items)
    end

    it 'redirect_to sign in page with unquthentication' do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'POST create' do
    it 'redirects to the my queue page' do
      session[:user_id] = Fabricate(:user).id
      post :create, video_id: Fabricate(:video).id
      expect(response).to redirect_to my_queue_path
    end

    it 'create a queue item' do
      session[:user_id] = Fabricate(:user).id
      post :create, video_id: Fabricate(:video).id
      expect(QueueItem.count).to eq(1)
    end

    it 'creates the queue item associated with video' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it 'creates the queue item associated with current_user' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(user)
    end

    it 'puts the video as the last one in the queue' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video, position: 1)
      monk = Fabricate(:video)
      post :create, video_id: monk.id
      expect(QueueItem.last.video).to eq(monk)
    end

    it 'does not add the video is already in the queue' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video, position: 1)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it 'redirects to sign in page if unauthenticated' do
      session[:user_id] = nil
      post :create, video_id: Fabricate(:video).id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'DELETE destroy' do
    it 'redirects to my queue page' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user, video: video)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it 'deletes the queue item' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user, video: video)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)      
    end

    it 'does not delete queue item that does not belong to current user' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: video)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it 'redirects to sign in page if unauthenticated' do
      delete :destroy, id: 1
      expect(response).to redirect_to sign_in_path      
    end
  end

end

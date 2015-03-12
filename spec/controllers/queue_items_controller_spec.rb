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

    it 'normalize the remaining queue items' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      queue_item = Fabricate(:queue_item, user: user, video: Fabricate(:video))
      queue_item2 = Fabricate(:queue_item, user: user, video: Fabricate(:video))
      delete :destroy, id: queue_item.id
      expect(QueueItem.first.position).to eq(queue_item2.reload.position)

    end
  end

  describe 'POST update_queue' do
    context 'with valid inputs' do
      it 'redirects to the my queue page' do
        user = Fabricate(:user)
        session[:user_id] = user.id        
        queue_item = Fabricate(:queue_item, user: user, video: Fabricate(:video))
        post :update_queue, queue_items: [{id: queue_item.id, position: queue_item.position}]
        expect(response).to redirect_to my_queue_path
      end

      it 'reorders the queue items' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user, video: Fabricate(:video), position: 1)
        queue_item2 = Fabricate(:queue_item, user: user, video: Fabricate(:video), position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(user.queue_items).to eq([queue_item2, queue_item1])
      end

      it 'normalize the position numbers' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user, video: Fabricate(:video), position: 2)
        queue_item2 = Fabricate(:queue_item, user: user, video: Fabricate(:video), position: 3)
        post :update_queue, queue_items: [{id: queue_item1.id, position: queue_item1.id}, {id: queue_item2.id, position: queue_item1.position}]
        
        expect(user.queue_items[0].position).to eq(1)
        expect(user.queue_items[1].position).to eq(2)
        
      end
    end

    context 'with invalid inputs' do
      
      it 'redirects to my queue page' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: user, video: Fabricate(:video))
        post :update_queue, queue_items: [{id: queue_item.id, position: 2.5}]
        expect(response).to redirect_to my_queue_path
      end
      
      it 'sets the flash error message' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: user, video: Fabricate(:video))
        post :update_queue, queue_items: [{id: queue_item.id, position: 2.5}]
        expect(flash[:error]).to be_present
      end
      
      it 'does not change the queue items' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: user, video: Fabricate(:video))
        post :update_queue, queue_items: [{id: queue_item.id, position: 2.5}]
        expect(QueueItem.first.position).to eq(1)
      end
    end

    context 'with unauthenticated' do
      it 'redirect to sign in page' do
        user = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: user, video: Fabricate(:video))
        post :update_queue, queue_items: [{id: queue_item.id, position: 2.5}]        
        expect(response).to redirect_to sign_in_path
      end
    end

    context 'with queue items do not belong to current user' do
      it 'redirects to my queue page' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: Fabricate(:video))
        post :update_queue, queue_items: [{id: queue_item.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end
      
      it 'only keep queue items belong to current user' do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: Fabricate(:video))
        post :update_queue, queue_items: [{id: queue_item.id, position: 1}]
        expect(user.queue_items.count).to eq(0)
      end
    end
  end

end

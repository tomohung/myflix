require 'spec_helper'

describe QueueItemsController do
  
  before { set_current_user }

  describe 'GET index' do
    it 'sets @queue_items with authentication' do
      queue_items = current_user.queue_items
      get :index
      expect(assigns(:queue_items)).to match_array(queue_items)
    end

    it_behaves_like 'require_sign_in' do
      let(:action) { get :index }
    end
  end

  describe 'POST create' do
    let(:video) { Fabricate(:video) }

    it_behaves_like 'queue_done' do
      let(:action) { post :create, video_id: Fabricate(:video).id }
    end

    it 'create a queue item' do
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it 'creates the queue item associated with video' do
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it 'creates the queue item associated with current_user' do
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(current_user)
    end

    it 'puts the video as the last one in the queue' do
      queue_item = Fabricate(:queue_item, user: current_user, video: video, position: 1)
      monk = Fabricate(:video)
      post :create, video_id: monk.id
      expect(QueueItem.last.video).to eq(monk)
    end

    it 'does not add the video is already in the queue' do
      queue_item = Fabricate(:queue_item, user: current_user, video: video, position: 1)
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like 'require_sign_in' do
      let(:action) { post :create, video_id: Fabricate(:video).id }
    end
  end

  describe 'DELETE destroy' do

    context 'with authenticated' do
      
      let(:video) { Fabricate(:video) }
      let(:queue_item) { Fabricate(:queue_item, user: current_user, video: video) }

      it_behaves_like 'queue_done' do
        let(:action) do
          queue_item = Fabricate(:queue_item, user: current_user, video: video)
          delete :destroy, id: queue_item.id
        end
      end

      it 'deletes the queue item' do
        queue_item = Fabricate(:queue_item, user: current_user, video: video)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)      
      end

      it 'does not delete queue item that does not belong to current user' do
        queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: video)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end
  
      it 'normalize the remaining queue items' do
        queue_item = Fabricate(:queue_item, user: current_user, video: Fabricate(:video))
        queue_item2 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video))
        delete :destroy, id: queue_item.id
        expect(QueueItem.first.position).to eq(queue_item2.reload.position)
      end
    end

    it_behaves_like 'require_sign_in' do
      let(:action) { delete :destroy, id: 1 }
    end
  end

  describe 'POST update_queue' do
    context 'with valid inputs' do

      it_behaves_like 'queue_done' do
        let(:action) do
          queue_item = Fabricate(:queue_item, user: current_user, video: Fabricate(:video))
          post :update_queue, queue_items: [{id: queue_item.id, position: queue_item.position}]
        end        
      end

      it 'reorders the queue items' do
        queue_item1 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: 1)
        queue_item2 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: 2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(current_user.queue_items).to eq([queue_item2, queue_item1])
      end

      it 'normalize the position numbers' do
        queue_item1 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: 2)
        queue_item2 = Fabricate(:queue_item, user: current_user, video: Fabricate(:video), position: 3)
        post :update_queue, queue_items: [{id: queue_item1.id, position: queue_item1.id}, {id: queue_item2.id, position: queue_item1.position}]
        expect(current_user.queue_items[0].position).to eq(1)
        expect(current_user.queue_items[1].position).to eq(2)
      end
    end

    context 'with invalid inputs' do
      
      let(:queue_item) { Fabricate(:queue_item, user: current_user, video: Fabricate(:video)) }

      it_behaves_like 'queue_done' do
        let(:action) { post :update_queue, queue_items: [{id: queue_item.id, position: 2.5}] }
      end
      
      it 'sets the flash error message' do
        post :update_queue, queue_items: [{id: queue_item.id, position: 2.5}]
        expect(flash[:error]).to be_present
      end
      
      it 'does not change the queue items' do
        post :update_queue, queue_items: [{id: queue_item.id, position: 2.5}]
        expect(QueueItem.first.position).to eq(1)
      end
    end

    it_behaves_like 'require_sign_in' do
      let(:action) do
        queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: Fabricate(:video))
        post :update_queue, queue_items: [{id: queue_item.id, position: 2.5}]        
      end
    end

    context 'with queue items do not belong to current user' do
      
      it_behaves_like 'queue_done' do
        let(:action) do
          queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: Fabricate(:video))
          post :update_queue, queue_items: [{id: queue_item.id, position: 2}]
        end
      end
      
      it 'only keep queue items belong to current user' do
        queue_item = Fabricate(:queue_item, user: Fabricate(:user), video: Fabricate(:video))
        post :update_queue, queue_items: [{id: queue_item.id, position: 1}]
        expect(current_user.queue_items.count).to eq(0)
      end
    end
  end

end

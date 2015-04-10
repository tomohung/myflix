require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'require_sign_in' do
      let(:action) { get :new }
    end

    it_behaves_like 'require admin' do
      let(:action) { get :new }
    end

    it 'sets the @video to a new video' do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_a_new Video
    end
  
    it 'sets the flash error message for regular user' do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end

  describe 'POST create' do
    it_behaves_like 'require_sign_in' do
      let(:action) { post :create }
    end

    it_behaves_like 'require admin' do
      let(:action) { post :create }
    end

    context 'with valid inputs' do
      it 'creates a video' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: 'video', description: 'fun movie', category_id: category.id }
        expect(category.videos.count).to eq(1)
      end

      it 'redirects to add new video page' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: 'video', description: 'fun movie', category_id: category.id }
        expect(response).to redirect_to new_admin_video_path
      end

      it 'sets the flash success message' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: 'video', description: 'fun movie', category_id: category.id }
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid inputs' do
      it 'does not create a video' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: 'fun movie', category_id: category.id }
        expect(category.videos.count).to eq(0)
      end

      it 'render the :new template' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: 'fun movie', category_id: category.id }
        expect(response).to render_template :new        
      end

      it 'sets the @video variable' do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { description: 'fun movie', category_id: category.id }
        expect(assigns(:video)).to be_instance_of Video
      end
    end
  end

end

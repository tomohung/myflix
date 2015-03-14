require 'spec_helper'

describe VideosController do 
  
  
  describe 'GET show' do

    let(:video) { Fabricate(:video) } 

    context 'with authentication' do      
      
      before { set_current_user }

      it 'sets @video' do
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it 'sets @reviews' do
        review1 = Fabricate(:review, video: video, user: current_user)
        review2 = Fabricate(:review, video: video, user: current_user)
        get :show, id: video.id
        expect(assigns(:reviews)).to match_array([review1, review2])
      end
    end

    it_behaves_like 'require_sign_in' do
      let(:action) { get :show, id: video.id }
    end
  end

  describe 'GET search' do
    
    let(:video) { Fabricate(:video) } 
    
    it 'sets @results if authenticated users' do
      set_current_user
      get :search, search_term: video.title
      expect(assigns(:results)).to eq([video])
    end

    it_behaves_like 'require_sign_in' do
      let(:action) { get :search, search_term: video.title }
    end
  end  
end

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

    context 'with unauthentication' do
      it 'redirect to sign in page' do
        get :show, id: video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe 'GET search' do
    
    let(:video) { Fabricate(:video) } 
    
    it 'sets @results if authenticated users' do
      set_current_user
      get :search, search_term: video.title
      expect(assigns(:results)).to eq([video])
    end

    it 'redirects to sign in page if unauthenticated' do
      get :search, search_term: video.title
      expect(response).to redirect_to sign_in_path
    end
  end
  
end

require 'spec_helper'

describe VideosController do 
  let(:video) { Fabricate(:video) } 
  describe 'GET show' do
    
    context 'with authentication' do
      
      let(:user) { Fabricate(:user)}
      before do
        session[:user_id] = user.id 
      end

      it 'sets @video' do
        get :show, id: video.id
        expect(assigns(:video)).to eq(video)
      end

      it 'sets @reviews' do
        
        review1 = Fabricate(:review, video: video, user: user)
        review2 = Fabricate(:review, video: video, user: user)
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
    it 'sets @results if authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :search, search_term: video.title
      expect(assigns(:results)).to eq([video])
    end

    it 'redirects to sign in page if unauthenticated' do
      get :search, search_term: video.title
      expect(response).to redirect_to sign_in_path
    end
  end
  
end

require 'spec_helper'

describe VideosController do 
  let(:video) { Fabricate(:video) } 
  describe 'GET show' do
    it 'set @video if authenticated users' do
      session[:user_id] = Fabricate(:user).id
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it 'redirect to sign in page if unauthenticated' do
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
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

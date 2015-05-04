require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    it 'redirects to home_path if authenticated' do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it 'renders new template if unauthenticated' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    context 'with authenticated' do
      let(:user) { Fabricate(:user) } 
      
      before do 
        post :create, email: user.email, password: user.password
      end

      it 'redirects to home_path' do
        expect(response).to redirect_to home_path
      end

      it 'sets session[:user_id]' do
        expect(session[:user_id]).to eq(User.first.id)
      end

      it 'sets notice' do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context 'with unauthenticated' do
      before do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password + 'lkjfd'
      end

      it 'redirects to sign_in_path' do
        expect(response).to redirect_to sign_in_path
      end

      it 'does not set session[:user_id]' do
        expect(session[:user_id]).to be_nil
      end

      it 'sets error message' do
        expect(flash[:danger]).not_to be_blank  
      end
    end
 end

  describe 'GET destroy' do
    context 'with authenticated' do
      before do
        set_current_user
        get :destroy
      end

      it 'sets session[:user_id] = nil if authenticated' do
        expect(session[:user_id]).to be_nil
      end
  
      it 'redirects_to root_path if authenticated' do
        expect(response).to redirect_to root_path
      end
    end

    context 'with unauthenticated' do
      before { get :destroy }      
      it 'sets session[:user_id] to nil if unauthenticated' do
        expect(session[:user_id]).to be_nil
      end
  
      it 'redirects_to root_path if unauthenticated' do
        expect(response).to redirect_to root_path
      end

      it 'set notice' do
        expect(flash[:notice]).not_to be_blank
      end
    end
  end
end

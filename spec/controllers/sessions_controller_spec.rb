require 'spec_helper'

describe SessionsController do

  describe 'GET new' do
    it 'redirects to home_path if authenticated' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      get :new
      expect(response).to redirect_to home_path
    end

    it 'renders new template if unauthenticated' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    it 'redirects to home_path if authenticated' do
      user = Fabricate(:user)
      post :create, email: user.email, password: user.password
      expect(response).to redirect_to home_path
    end

    it 'redirects to sign_in_path if unauthenticated' do
      post :create
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'GET destroy' do
    it 'sets session[:user_id] = nil if authenticated' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'sets session[:user_id] to nil if unauthenticated' do
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects_to root_path if authenticated' do
      user = Fabricate(:user)
      session[:user_id] = user.id
      get :destroy
      expect(response).to redirect_to root_path
    end

    it 'redirects_to root_path if unauthenticated' do
      get :destroy
      expect(response).to redirect_to root_path
    end
  end
end

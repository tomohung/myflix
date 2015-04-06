require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    it 'renders show template if token is valid' do
      user = Fabricate(:user)
      get :show, id: user.token
      expect(response).to render_template :show
    end

    it 'redirects to expired token page if the token is not valid' do
      get :show, id: 'asdfa'
      expect(response).to redirect_to expired_token_path
    end

    it 'sets @token' do
      user = Fabricate(:user)
      user.update_column(:token, '12345')
      get :show, id: user.token
      expect(assigns(:token)).to eq('12345')
    end
  end

  describe 'POST create' do
    context 'with valid token' do
      it 'update user password' do
        user = Fabricate(:user)
        new_password = 'new password'
        post :create, token: user.token, password: new_password
        expect(user.reload.authenticate('new password')).to be_present
      end

      it 'redirects to the sign in page' do
        user = Fabricate(:user)
        new_password = 'new password'
        post :create, token: user.token, password: new_password
        expect(response).to redirect_to sign_in_path
      end

      it 'sets the flash success message' do
        user = Fabricate(:user)
        new_password = 'new password'
        post :create, token: user.token, password: new_password
        expect(flash[:notice]).to be_present
      end

      it 'regenreates the user token' do
        user = Fabricate(:user)
        new_password = 'new password'
        token = user.token
        post :create, token: user.token, password: new_password
        expect(user.reload.token).not_to eq(token)
      end
    end

    context 'with invalid token' do
      it 'redirects to the expired token path' do
        post :create, token: 'asdfadf', password: 'slkjfsdf'
        expect(response).to redirect_to expired_token_path
      end
    end

  end
end

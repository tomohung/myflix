require 'spec_helper'

describe UsersController do
  
  describe 'GET new' do
    it 'sets @user' do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end

    it 'should render new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET new_with_invitation_token' do
    it 'sets @user with recipient_email' do
      invitation = Fabricate(:invitation, inviter: Fabricate(:user))
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user)).to be_instance_of User
    end
    
    it 'redirects to expired token page for invalid token' do      
      get :new_with_invitation_token, token: 'asdfasdf'
      expect(response).to redirect_to expired_token_path
    end
    
    it 'renders :new template' do
      invitation = Fabricate(:invitation, inviter: Fabricate(:user))
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it 'sets invitation_token' do
      user = Fabricate(:user)
      invitation = Fabricate(:invitation, inviter: user)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
  end

  describe 'POST create' do
    context 'with valid input' do

      it 'should logged_in if create user' do
        result = double(:sign_up, successful?: true)
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        expect_any_instance_of(User).to receive(:id).and_return(1)
        post :create, user: Fabricate.attributes_for(:user)
        expect(session[:user_id]).to eq(1)
      end

      it 'should redirect to home_path' do
        result = double(:sign_up, successful?: true)
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end
    end

    context 'with invliad input' do
      
      before do
        result = double(:sign_up, successful?: false, error_message: 'error', )
        expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: { password: 'slkjdf'}
      end

      it 'render template :new' do
        expect(response).to render_template :new
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe 'GET show' do
    it_behaves_like 'require_sign_in' do
      let(:action) { get :show, id: 1}
    end

    it 'sets @user' do
      set_current_user
      bob = Fabricate(:user)
      get :show, id: bob.token
      expect(assigns(:user)).to eq(bob)
    end
  end
end

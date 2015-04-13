require 'spec_helper'
require 'stripe_mock'

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
      let(:stripe_helper) { StripeMock.create_test_helper }
      after { StripeMock.stop }

      before do
        StripeMock.start
        post :create, user: Fabricate.attributes_for(:user), stripToken: stripe_helper.generate_card_token
      end

      it 'should create user' do
        expect(User.count).to eq(1)  
      end

      it 'should logged_in if create user' do
        expect(session[:user_id]).to eq(User.first.id)
      end

      it 'should redirect to home_path' do
        expect(response).to redirect_to home_path
      end
    end

    context 'with invliad input' do
      
      before do
        post :create, user: { password: 'slkjdf'}
      end
      
      it 'does not create the user' do 
        expect(User.count).to eq(0)
      end

      it 'render template :new' do
        expect(response).to render_template :new
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context 'sending email' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      after { StripeMock.stop }

      before do
        StripeMock.start
        ActionMailer::Base.deliveries.clear
      end

      it 'sends out email to the user with valid inputs' do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes, stripToken: stripe_helper.generate_card_token
        expect(ActionMailer::Base.deliveries.last.to).to eq([user_attributes["email"]])
      end

      it 'sends out email containing user name with valid inputs' do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes, stripToken: stripe_helper.generate_card_token
        expect(ActionMailer::Base.deliveries.last.body).to include(user_attributes["full_name"])
      end
      it 'does not send out email with invalid inputs' do
        post :create, user: { email: 'a@email.com'}, stripToken: stripe_helper.generate_card_token
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context 'create by invitation' do
      let(:stripe_helper) { StripeMock.create_test_helper }
      after { StripeMock.stop }

      before { StripeMock.start }

      it 'makes the user follow the inviter' do
        user = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user)
        post :create, user: { email: 'joe@example.com', password: 'joejoejoe', full_name: 'Joe'}, token: invitation.token, stripToken: stripe_helper.generate_card_token
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(user)).to be true
      end

      it 'makes the inviter follow the user' do
        user = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user)
        post :create, user: { email: 'joe@example.com', password: 'joejoejoe', full_name: 'Joe'}, token: invitation.token, stripToken: stripe_helper.generate_card_token
        joe = User.find_by(email: 'joe@example.com')
        expect(user.follows?(joe)).to be true
      end

      it 'expires the invitation upon acceptance' do
        user = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: user)
        post :create, user: { email: 'joe@example.com', password: 'joejoejoe', full_name: 'Joe'}, token: invitation.token, stripToken: stripe_helper.generate_card_token
        expect(Invitation.first.token).to be nil
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

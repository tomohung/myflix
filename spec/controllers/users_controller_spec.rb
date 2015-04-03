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

  describe 'POST create' do
    context 'with valid input' do
      before do
        post :create, user: Fabricate.attributes_for(:user)
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
      before { ActionMailer::Base.deliveries.clear }

      it 'sends out email to the user with valid inputs' do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes
        expect(ActionMailer::Base.deliveries.last.to).to eq([user_attributes["email"]])
      end

      it 'sends out email containing user name with valid inputs' do
        user_attributes = Fabricate.attributes_for(:user)
        post :create, user: user_attributes
        expect(ActionMailer::Base.deliveries.last.body).to include(user_attributes["full_name"])
      end
      it 'does not send out email with invalid inputs' do
        post :create, user: { email: 'a@email.com'}
        expect(ActionMailer::Base.deliveries).to be_empty
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

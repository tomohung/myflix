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

  end

end

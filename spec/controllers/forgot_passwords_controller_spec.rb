require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context 'with blank input' do
      it 'redirects to the forgot password page' do
        post :create
        expect(response).to redirect_to forgot_password_path
      end
      it 'show an error messages' do
        post :create
        expect(flash[:error]).to be_present
      end
    end

    context 'with existing email' do
      it 'redirects to the forgot password confirm page' do
        user = Fabricate(:user, email: 'a@example.com')
        post :create, email: user.email
        expect(response).to redirect_to forgot_password_confirm_path
      end
      
      it 'sends out an email to email address' do
        user = Fabricate(:user, email: 'a@example.com')
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.last.to).to eq(['a@example.com'])
      end
    end

    context 'with non-existing email' do
      it 'redirects to the forgot password page' do
        post :create, email: 'a@example.com'
        expect(response).to redirect_to forgot_password_path
      end

      it 'shows an error message' do
        post :create, email: 'a@example.com'
        expect(flash[:error]).to be_present
      end
    end
  end
end
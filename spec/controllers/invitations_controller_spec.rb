require 'spec_helper'

describe InvitationsController do

  describe 'GET new' do
    it 'sets @invitation to a new invitation' do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new Invitation
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe 'POST create' do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    context 'with valiad inputs' do
      before do
        ActionMailer::Base.deliveries.clear
        set_current_user
      end

      it 'creates an invitation' do
        post :create, invitation: { recipient_name: 'Joe', recipient_email: 'joe@example.com', message: 'come to join us.'}
        expect(Invitation.count).to eq(1)
      end

      it 'sends out an email to the recipient' do
        post :create, invitation: { recipient_name: 'Joe', recipient_email: 'joe@example.com', message: 'come to join us.'}
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it 'redirects to the invitation new page' do
        post :create, invitation: { recipient_name: 'Joe', recipient_email: 'joe@example.com', message: 'come to join us.'}
        expect(response).to redirect_to new_invitation_path
      end

      it 'sets the flash success message' do
        post :create, invitation: { recipient_name: 'Joe', recipient_email: 'joe@example.com', message: 'come to join us.'}
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid inputs' do
      
      before do
        ActionMailer::Base.deliveries.clear
        set_current_user
      end

      it 'does not create an invitation' do
        post :create, invitation: { recipient_email: 'joe@example.com', message: 'come to join us.'}
        expect(Invitation.count).to eq(0)
      end

      it 'does not send out email' do
        post :create, invitation: { recipient_email: 'joe@example.com', message: 'come to join us.'}
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'sets the flash error messages' do
        post :create, invitation: { recipient_email: 'joe@example.com', message: 'come to join us.'}
        expect(flash[:danger]).to be_present
      end

      it 'sets @invitation' do
        post :create, invitation: { recipient_email: 'joe@example.com', message: 'come to join us.'}
        expect(assigns(:invitation)).to be_instance_of Invitation
      end

      it 'render new template' do
        post :create, invitation: { recipient_email: 'joe@example.com', message: 'come to join us.'}
        expect(response).to render_template :new
      end
    end
  end

end
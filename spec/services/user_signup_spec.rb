require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context 'with valid personal info and card' do
      before do
        charge = double(:charge, success?: true)
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it 'returns successful' do
        user = Fabricate.build(:user)
        result = UserSignup.new(user).sign_up("stripe_token")
        expect(result).to be_successful
      end

      it 'should create user' do
        user = Fabricate.build(:user)
        result = UserSignup.new(user).sign_up("stripe_token")
        expect(User.count).to eq(1)
      end
    end

    context 'with invliad personal info and card' do
      before do
        charge = double(:charge, success?: false, error_message: 'invalid card')
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it 'returns not successful' do
        user = Fabricate.build(:user)
        result = UserSignup.new(user).sign_up("stripe_token")
        expect(result.error_message).to be_present
      end

      it 'does not create the user' do 
        user = Fabricate.build(:user)
        result = UserSignup.new(user).sign_up("stripe_token")
        expect(User.count).to eq(0)
      end
    end

    context 'sending email' do

      before do
        charge = double(:charge, success?: true)
        StripeWrapper::Charge.stub(:create).and_return(charge)
        ActionMailer::Base.deliveries.clear
      end

      it 'sends out email to the user with valid inputs' do
        user = Fabricate.build(:user)
        result = UserSignup.new(user).sign_up("stripe_token")
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
      end

      it 'sends out email containing user name with valid inputs' do
        user = Fabricate.build(:user)
        result = UserSignup.new(user).sign_up("stripe_token")
        expect(ActionMailer::Base.deliveries.last.body).to include(user.full_name)
      end
      it 'does not send out email with invalid inputs' do
        user = User.new(email: 'joe@example.com')
        result = UserSignup.new(user).sign_up("stripe_token")
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context 'create by invitation' do

      let(:user) { Fabricate(:user) }
      before do
        charge = double(:charge, success?: true)
        StripeWrapper::Charge.stub(:create).and_return(charge)
        invitation = Fabricate(:invitation, inviter: user)
        joe = User.new(email: 'joe@example.com', password: 'joejoejoe', full_name: 'Joe')
        UserSignup.new(joe).sign_up("stripe_token", invitation.token)
      end

      it 'makes the user follow the inviter' do
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(user)).to be true
      end

      it 'makes the inviter follow the user' do
        joe = User.find_by(email: 'joe@example.com')
        expect(user.follows?(joe)).to be true
      end

      it 'expires the invitation upon acceptance' do
        expect(Invitation.first.token).to be nil
      end
    end


  end
end
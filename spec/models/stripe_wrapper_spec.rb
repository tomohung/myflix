require 'spec_helper'

describe StripeWrapper, vcr: true do
  
  let(:valid_token) {
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 4,
        :exp_year => 2016,
        :cvc => "314"
      },
    ).id
  }
  
  let(:invalid_token) {
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 4,
        :exp_year => 2016,
        :cvc => "314"
      },
    ).id
  }

  describe StripeWrapper::Charge do
    it 'makes successful charge' do
      charge = StripeWrapper::Charge.create(amount: 100, source: valid_token)
      expect(charge.response.amount).to eq(100)
      expect(charge.response.currency).to eq('usd')
      expect(charge).to be_success
    end

    it 'does not make a charge with invalid card' do
      charge = StripeWrapper::Charge.create(amount: 100, source: invalid_token)
      expect(charge).not_to be_success
    end      
  end

  describe "StripeWrapper::customer" do
    it 'create a customer with valid card' do
      user = Fabricate(:user)
      charge = StripeWrapper::Charge.customer(source: valid_token, email: user.email)
      expect(charge).to be_success
    end

    it 'does not create a customer with declined card' do
      user = Fabricate(:user)
      charge = StripeWrapper::Charge.customer(source: invalid_token, email: user.email)
      expect(charge).not_to be_success
    end

    it 'return error message with declined card' do
      user = Fabricate(:user)
      charge = StripeWrapper::Charge.customer(source: invalid_token, email: user.email)
      expect(charge.error_message).to be_present
    end

  end

end

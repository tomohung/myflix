require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    it 'makes successful charge', vcr: true do
      StripeWrapper.set_api_key
      token = Stripe::Token.create(
        :card => {
          :number => "4242424242424242",
          :exp_month => 4,
          :exp_year => 2016,
          :cvc => "314"
        },
      ).id

      charge = StripeWrapper::Charge.create(amount: 100, source: token)
      expect(charge.response.amount).to eq(100)
      expect(charge.response.currency).to eq('usd')
      expect(charge).to be_success
    end

  end

end
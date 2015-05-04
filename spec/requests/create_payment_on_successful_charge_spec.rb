require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
      "id"=> "evt_15yYzgLCTUylKIRln74HkdCq",
      "created"=> 1430705260,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_15yYzgLCTUylKIRlP66CKpX5",
          "object"=> "charge",
          "created"=> 1430705260,
          "livemode"=> false,
          "paid"=> true,
          "status"=> "succeeded",
          "amount"=> 99,
          "currency"=> "usd",
          "refunded"=> false,
          "source"=> {
            "id"=> "card_15yYzeLCTUylKIRll7zhkfMs",
            "object"=> "card",
            "last4"=> "4242",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 5,
            "exp_year"=> 2015,
            "fingerprint"=> "Z2GkECNfVSpQKiE3",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil,
            "dynamic_last4"=> nil,
            "metadata"=> {},
            "customer"=> "cus_6Aupm1THLvHTnO"
          },
          "captured"=> true,
          "balance_transaction"=> "txn_15yYzgLCTUylKIRluBT7Obmz",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_6Aupm1THLvHTnO",
          "invoice"=> "in_15yYzgLCTUylKIRlcnjWhIBb",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {},
          "statement_descriptor"=> nil,
          "fraud_details"=> {},
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil,
          "application_fee"=> nil,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_15yYzgLCTUylKIRlP66CKpX5/refunds",
            "data"=> []
          }
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_6AupyN8zrE6fF4",
      "api_version"=> "2015-04-07"
    }    
  end

  it 'creates a payment with webhood from stripe for charge succeed', vcr: true do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it 'create the payment associated with user', vcr: true do
    user = Fabricate(:user, customer_token: 'cus_6Aupm1THLvHTnO')
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(user)
  end

  it 'creates payment with the amount', vcr: true do
    user = Fabricate(:user, customer_token: 'cus_6Aupm1THLvHTnO')
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(99)    
  end

  it 'creates payment with reference id', vcr: true do
    user = Fabricate(:user, customer_token: 'cus_6Aupm1THLvHTnO')
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("ch_15yYzgLCTUylKIRlP66CKpX5")
  end
end

require 'spec_helper'

describe 'customer on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_15ycOeLCTUylKIRlJom1jayI",
      "created" => 1430718340,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15ycOdLCTUylKIRlq8G764Gc",
          "object" => "charge",
          "created" => 1430718339,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 99,
          "currency" => "usd",
          "refunded" => false,
          "source" => {
            "id" => "card_15ycOALCTUylKIRlaEUsukcJ",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 5,
            "exp_year" => 2016,
            "fingerprint" => "Pfqqgr2TZjeNXbHD",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_6Awy7ItkTK5HCv"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_6Awy7ItkTK5HCv",
          "invoice" => nil,
          "description" => "payment fail",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15ycOdLCTUylKIRlq8G764Gc/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_6AyLkbPGvZltpn",
      "api_version" => "2015-04-07"
    }
  end


  it 'deactivates a user with the webhook data from stripe for charge failed', vcr: true do
    user = Fabricate(:user, customer_token: "cus_6Awy7ItkTK5HCv", active: true)
    post '/stripe_events', event_data
    expect(user.reload).not_to be_active
  end
end

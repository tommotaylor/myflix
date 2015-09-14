require 'rails_helper'

describe 'Deactivate account on failed charge' do
  let(:event_data) do {
    "id"=> "evt_16kY3g44VM564LCCtLTTswBu",
    "created"=> 1442141408,
    "livemode"=> false,
    "type"=> "charge.failed",
    "data"=> {
      "object"=> {
        "id"=> "ch_16kY3f44VM564LCCjpFVDPhz",
        "object"=> "charge",
        "created"=> 1442141407,
        "livemode"=> false,
        "paid"=> false,
        "status"=> "failed",
        "amount"=> 999,
        "currency"=> "gbp",
        "refunded"=> false,
        "source"=> {
          "id"=> "card_16kY3144VM564LCCPlyPHLib",
          "object"=> "card",
          "last4"=> "0341",
          "brand"=> "Visa",
          "funding"=> "credit",
          "exp_month"=> 9,
          "exp_year"=> 2017,
          "fingerprint"=> "NByy752xLXi2AKT8",
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
          "tokenization_method"=> nil,
          "dynamic_last4"=> nil,
          "metadata"=> {},
          "customer"=> "cus_6xpD9ZyyfRjkpR"
        },
        "captured"=> false,
        "balance_transaction"=> nil,
        "failure_message"=> "Your card was declined.",
        "failure_code"=> "card_declined",
        "amount_refunded"=> 0,
        "customer"=> "cus_6xpD9ZyyfRjkpR",
        "invoice"=> nil,
        "description"=> "Failed test",
        "dispute"=> nil,
        "metadata"=> {},
        "statement_descriptor"=> "Failed test",
        "fraud_details"=> {},
        "receipt_email"=> nil,
        "receipt_number"=> nil,
        "shipping"=> nil,
        "destination"=> nil,
        "application_fee"=> nil,
        "refunds"=> {
          "object"=> "list",
          "total_count"=> 0,
          "has_more"=> false,
          "url"=> "/v1/charges/ch_16kY3f44VM564LCCjpFVDPhz/refunds",
          "data"=> []
        }
      }
    },
    "object"=> "event",
    "pending_webhooks"=> 1,
    "request"=> "req_6yV3SNcWgkLizw",
    "api_version"=> "2015-08-19"
  }
  end

  it "deactivates the users account", :vcr do
    user = Fabricate(:user, customer_token: 'cus_6xpD9ZyyfRjkpR')
    post '/stripe_events', event_data
    expect(User.first).to_not be_active
  end
end
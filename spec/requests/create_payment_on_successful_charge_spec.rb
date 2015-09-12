require 'rails_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
      {
        id: "evt_16kBFo44VM564LCCp06XrqmL",
        created: 1442053748,
        livemode: false,
        type: "charge.succeeded",
        data:
        { object: 
          { id: "ch_16kBFo44VM564LCCzqVN3Url",
            object: "charge",
            created: 1442053748,
            livemode: false,
            paid: true,
            status: "succeeded",
            amount: 999,
            currency: "gbp",
            refunded: false,
            source:
            { id: "card_16kBFm44VM564LCCBpQH2FtK",
              object: "card",
              last4: "4242",
              brand: "Visa",
              funding: "credit",
              exp_month: 9,
              exp_year: 2017,
              fingerprint: "oVapSLScRj2xH9u5",
              country: "US",
              name: nil,
              address_line1: nil,
              address_line2: nil,
              address_city: nil,
              address_state: nil,
              address_zip: nil,
              address_country: nil,
              cvc_check: "pass",
              address_line1_check: nil,
              address_zip_check: nil,
              tokenization_method: nil,
              dynamic_last4: nil,
              metadata: {},
              customer: "cus_6y7UvuCjdGwQKU" },
            captured: true,
            balance_transaction: "txn_16kBFo44VM564LCCuR9mWjFj",
            failure_message: nil,
            failure_code: nil,
            amount_refunded: 0,
            customer: "cus_6y7UvuCjdGwQKU",
            invoice: "in_16kBFo44VM564LCCV151BXZA",
            description: nil,
            dispute: nil,
            metadata: {},
            statement_descriptor: "MYFLIX MONTHLY SUB",
            fraud_details: {},
            receipt_email: nil,
            receipt_number: nil,
            shipping: nil,
            destination: nil,
            application_fee: nil,
            refunds:
            { object: "list",
              total_count: 0,
              has_more: false,
              url: "/v1/charges/ch_16kBFo44VM564LCCzqVN3Url/refunds",
              data: 
              []
            }
          }
        }
      }
  end

  it "creates a payment with the webhook from Stripe for charge succeeded", :vcr do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    user = Fabricate(:user, customer_token: "cus_6y7UvuCjdGwQKU")
    post '/stripe_events', event_data
    expect(Payment.last.user).to eq(user)
  end

  it "saves the amount to the Payment", :vcr do
    user = Fabricate(:user, customer_token: "cus_6y7UvuCjdGwQKU")
    post '/stripe_events', event_data
    expect(Payment.last.amount).to eq(999)
  end

  it "saves the reference_id to the payment", :vcr do
    user = Fabricate(:user, customer_token: "cus_6y7UvuCjdGwQKU")
    post '/stripe_events', event_data
    expect(Payment.last.reference_id).to eq("ch_16kBFo44VM564LCCzqVN3Url")
  end
end
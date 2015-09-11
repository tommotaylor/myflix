require 'rails_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    { object:
      { id: "ch_16jtZ144VM564LCCjuhXXy9c",
        object: "charge",
        created: 1441985747,
        livemode: false,
        paid: true,
        status: "succeeded",
        amount: 999,
        currency: "gbp",
        refunded: false,
        source:
        { id: "card_16jtYz44VM564LCCKAuZ6T2z",
          object: "card",
          last4: "4242",
          brand: "Visa",
          funding: "credit",
          exp_month: 9,
          exp_year: 2019,
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
          customer: "cus_6xpD9ZyyfRjkpR" },
        captured: true,
        balance_transaction: "txn_16jtZ144VM564LCCOyP1eLGo",
        failure_message: nil,
        failure_code: nil,
        amount_refunded: 0,
        customer: "cus_6xpD9ZyyfRjkpR",
        invoice: "in_16jtZ144VM564LCC6o2Tr2ci",
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
          url: "/v1/charges/ch_16jtZ144VM564LCCjuhXXy9c/refunds",
          data: [] }}}
  end

  it "creates a payment with the webhook from Stripe for charge succeeded" do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user" do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end
end
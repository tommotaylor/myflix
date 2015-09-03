require 'rails_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "creates a successful charge", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 9,
            :exp_year => 2016,
            :cvc => "314"
          },
        )
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => token
        )

        expect(response).to be_successful
      end

      it "declines a card", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 9,
            :exp_year => 2016,
            :cvc => "314"
          },
        )
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => token
        )

        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges", :vcr do
        token = Stripe::Token.create(
          :card => {
            :number => "4000000000000002",
            :exp_month => 9,
            :exp_year => 2016,
            :cvc => "314"
          },
        )
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => token
        )

        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
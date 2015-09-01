require 'rails_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "creates a successful charge", :vcr do
        Stripe.api_key = ENV['SECRET_KEY']
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 9,
            :exp_year => 2016,
            :cvc => "314"
          },
        )
        charge = StripeWrapper::Charge.create(
          :amount => 999,
          :source => token
        )

        expect(charge.amount).to eq(999)        
        expect(charge.currency).to eq('gbp')
      end
    end
  end
end
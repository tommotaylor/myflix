require 'rails_helper'

describe StripeWrapper do
  let(:valid_token) do        
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 9,
        :exp_year => 2016,
        :cvc => "314" }).id
  end

  let(:declined_token) do          
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 9,
        :exp_year => 2016,
        :cvc => "314" }).id
  end

  describe StripeWrapper::Charge do
    describe ".create", :vcr do
      it "creates a successful charge" do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => valid_token )
        expect(response).to be_successful
      end

      it "declines a card" do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => declined_token )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined charges" do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => declined_token )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create", :vcr do

      it "creates a customer when successful" do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          :email => user.email,
          :source => valid_token)
        expect(response).to be_successful
      end
      
      it "returns the customer_token when successful" do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          :email => user.email,
          :source => valid_token)
        expect(response.customer_token).to be_present
      end

      it "doesn't create customer when unsuccesful" do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          :email => user.email,
          :source => declined_token)
        expect(response).to_not be_successful
      end

      it "returns the error message" do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          :email => user.email,
          :source => declined_token)
        expect(response.error_message).to eq("Your card was declined.")
      end

      it "returns the customer_token" do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          :email => user.email,
          :source => valid_token)
        expect(response.customer_token).to be_present
      end
    end
  end
end
module StripeWrapper

  class Charge

    attr_reader :error_message, :response

    def initialize(options={})
      @error_message = options[:error_message] 
      @response = options[:response]
    end
    
    def self.create(options={})
      response = Stripe::Charge.create(
        :amount      => options[:amount],
        :description => 'Myflix signup charge',
        :currency    => 'gbp',
        :source      => options[:source])
      customer = Stripe::Customer.create(
        :source => options[:source],
        :plan => "Standard")      
      new(response: response)
    rescue Stripe::CardError => e
      new(error_message: e.message)
    end

    def successful?
      response.present?
    end
  end
end
module StripeWrapper

  class Charge
    def self.create(options={})
      StripeWrapper.set_api_key
      Stripe::Charge.create(
        :amount      => options[:amount],
        :description => 'Myflix signup charge',
        :currency    => 'gbp',
        :source      => options[:source])
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV['SECRET_KEY']
  end

end
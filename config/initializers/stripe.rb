Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = ENV['SECRET_KEY']

# StripeEvent.setup do
#   subscribe 'charge.succeeded' do |event|
#     Payment.create
#   end
# end

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    Payment.create
  end
end
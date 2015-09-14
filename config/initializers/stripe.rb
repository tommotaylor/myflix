Rails.configuration.stripe = {
  :publishable_key => ENV['PUBLISHABLE_KEY'],
  :secret_key      => ENV['SECRET_KEY']
}

Stripe.api_key = ENV['SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    user = User.find_by(customer_token: event.data.object.source.customer)
    Payment.create(
      user: user, 
      amount: event.data.object.amount,
      reference_id: event.data.object.id )
  end

  events.subscribe 'charge.failed' do |event|
    user = User.find_by(customer_token: event.data.object.source.customer)
    user.deactivate!    
  end
end
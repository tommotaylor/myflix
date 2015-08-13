Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :port           => ENV['587'],
    :address        => ENV['smtp.mailgun.org'],
    :user_name      => ENV['postmaster@m.mysterious-atoll-5027.herokuapp.com'],
    :password       => ENV['8933b7e7abda6f222419344715df22d0'],
    :domain         => 'mysterious-atoll-5027.herokuapp.com',
    :authentication => :plain }
end

Rails.application.routes.default_url_options[:host] = "https://mysterious-atoll-5027.herokuapp.com"

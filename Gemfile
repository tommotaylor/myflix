source 'https://rubygems.org'
ruby '2.1.7'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt'
gem 'bootstrap_form'
gem 'figaro'
gem 'sidekiq'
gem 'unicorn'
gem 'sentry-raven'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'mini_magick'
gem 'stripe'
gem 'draper'
gem 'stripe_event'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.0'
  gem 'faker'
  gem 'capybara', :git => 'https://github.com/jnicklas/capybara.git'
  gem 'capybara-email'
  gem 'simplecov', :require => false
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'launchy'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem "capybara-webkit"
end

group :production do
  gem 'rails_12factor'
end


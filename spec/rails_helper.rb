# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/email/rspec'
# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rails'
require 'sidekiq/testing'
require 'carrierwave/test/matchers'
require 'vcr'
Sidekiq::Testing.inline!

Capybara.server_port = 52662
Capybara.javascript_driver = :webkit
Capybara::Webkit.configure do |config|
  config.allow_url("api.stripe.com")
  config.allow_url("js.stripe.com")
  config.allow_url("www.gravatar.com")
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
end


RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.include(ControllerMacros, :type => :controller)
  config.include(FeatureMacros, :type => :feature)
  config.include(ModelMacros, :type => :model)
  config.before(:each, elasticsearch: true) do
    Video.__elasticsearch__.create_index! force: true
  end
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

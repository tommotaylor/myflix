require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

Fog.credentials = { :path_style => true }

module Myflix
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true

    config.assets.enabled = true
    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end
  end
end

# Load the rails application
require File.expand_path('../application', __FILE__)

module Mage
  class Application < Rails::Application
    attr_accessor :settings
    config.encoding = "utf-8"
  end
end

ActiveSupport::Inflector.inflections do |inflection| 
  inflection.uncountable "journal"
end

# Initialize the rails application
Mage::Application.initialize!

Sass::Plugin.options[:template_location] = { 'app/stylesheets' => 'public/stylesheets' }

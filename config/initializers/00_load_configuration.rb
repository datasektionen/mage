filename = Rails.root + "config/configuration.yml"
raise "Missing config/configuration.yml" unless File.exists?(filename)
yaml = YAML.load_file(filename)
if yaml.has_key?(Rails.env)
  Cashflow::Application.settings = ActiveSupport::HashWithIndifferentAccess.new(yaml["common"].merge(yaml[Rails.env]||{}))
else
  raise "Missing settings for environment #{Rails.env}" unless Rails.env == "test"
end

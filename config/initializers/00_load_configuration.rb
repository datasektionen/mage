filename = Rails.root + 'config/configuration.yml'
fail 'Missing config/configuration.yml' unless File.exist?(filename)
yaml = YAML.load_file(filename)
if yaml.key?(Rails.env)
  Mage::Application.settings = ActiveSupport::HashWithIndifferentAccess.new(yaml['common'].merge(yaml[Rails.env] || {}))
else
  fail "Missing settings for environment #{Rails.env}" unless Rails.env == 'test'
end

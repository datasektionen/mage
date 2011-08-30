source 'http://rubygems.org'

gem 'rails', '~> 3.0.9'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'RedCloth'
gem 'sass'
gem 'inherited_resources'
gem 'has_scope'
gem 'simple_form'
gem 'devise'
gem 'oa-enterprise', :git => 'https://github.com/intridea/omniauth.git'
gem 'oa-oauth', :git => 'https://github.com/intridea/omniauth.git'
gem 'i18n_routing'
gem 'friendly_id'
gem 'net-ldap'
gem 'haml-rails'
gem 'simple-navigation'
gem 'jquery-rails', '>= 1.0.12'
gem 'prawn', :git=>'https://github.com/sandal/prawn.git', :submodules=>true
gem 'rqrcode'
gem 'prawn-qrcode', '~> 0.1.1', :git=>'https://github.com/torandi/prawn-qrcode.git'
gem 'cancan'

group :production do
  gem 'mysql2', '~> 0.2.6'
  gem 'unicorn'
end

group :development, :test do
  gem 'rspec-rails'
end

group :development do
  gem 'mysql2', '~> 0.2.6'
end

group :test do
  gem 'ruby-debug19'
  gem 'rcov'
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'machinist', '>= 2.0.0.beta2'
  gem 'autotest'
end

group :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
end

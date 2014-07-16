source 'https://rubygems.org'

gem 'rails', '~> 3.0.9'

gem 'RedCloth'
gem 'sass'
gem 'inherited_resources'
gem 'has_scope'
gem 'simple_form'
gem 'devise', '1.4.9'
gem 'oa-enterprise'
gem 'oa-oauth'
gem 'i18n_routing'
gem 'friendly_id', '~> 4.0.0'
gem 'net-ldap'
gem 'haml-rails'
gem 'simple-navigation'
gem 'jquery-rails'
gem 'prawn', :git=>'https://github.com/prawnpdf/prawn', :submodules=>true
gem 'rqrcode'
gem 'prawn-qrcode', '~> 0.1.1', :git=>'https://github.com/torandi/prawn-qrcode.git'
gem 'cancan'
gem 'kaminari'
gem 'airbrake'
gem 'sunspot_rails'
gem 'progress_bar'
gem 'enum_column3'
gem 'nokogiri', '~> 1.5.4'
gem 'mysql2', '~> 0.2.6'

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem 'rspec', '~> 2.8.0'
  gem 'rspec-rails'
  gem 'guard', '>= 1.0.0'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'libnotify'
  gem 'rb-inotify'
  gem 'sunspot_solr'
end

group :test do
  gem 'ruby-debug19'
  gem 'rcov', '< 1.0.0'
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'machinist', '>= 2.0.0.beta2'
end

group :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
end

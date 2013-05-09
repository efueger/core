source 'https://rubygems.org'

# Core
gem 'rails', '~> 3.2.13'

# Database
gem 'pg', '~> 0.14.0'

gem 'haml-rails',      '~> 0.3.4'
gem 'jquery-rails',    '~> 2.1.1'
gem 'bootstrap-sass',  '~> 2.1.0.0'
gem 'select2-rails',   '~> 3.2.1'
gem 'ember-rails',     '~> 0.7.0'

gem 'json',                 '~> 1.7.7'
gem 'devise',               '~> 2.1.2'
gem 'multi_json',           '~> 1.3.6'
gem 'simple_form',          '~> 2.0.2'
gem 'inherited_resources',  '~> 1.3.1'
gem 'mini_magick',          '~> 3.4'
gem 'carrierwave',          '~> 0.6.2'
gem 'money-rails',          '~> 0.5.0'
gem 'acts-as-taggable-on',  '~> 2.3.3'
gem 'pg_search',            '~> 0.5.1'
gem 'whenever',             '~> 0.7.3'
gem 'acts_as_list',         '~> 0.1.8'
gem 'default_value_for',    '~> 2.0.1'
gem 'fuzzy-string-match',   '~> 0.9.4',  require: 'fuzzystringmatch' # This performs fuzzy matching on the import script
gem 'state_machine',        '~> 1.1.2'

gem 'postmark-rails',  '~> 0.4.1'
gem 'analytical',      '~> 3.0.12'
gem 'newrelic_rpm',    '~> 3.6.1'
gem 'airbrake',        '~> 3.1.2'

gem 'ace-rails-ap',  '~> 2.0.0'

gem 'activemerchant'
gem 'attr_encryptor'

########## THE GEMS ABOVE ARE THE ONLY ONES THAT RUN ON PRODUCTION ##########

group :assets do
  gem 'coffee-rails',   '~> 3.2.2'
  gem 'uglifier',       '~> 1.2.7'
  gem 'sass-rails',     '~> 3.2.5'
  gem 'compass-rails',  '~> 1.0.3'
end

group :install do
  gem 'sprinkle',  github: 'jordandcarter/sprinkle' # patched to be awesome.. added more verifiers and updated some installers
end

group :development do
  gem 'bullet',     '~> 4.6.0', require: false
  gem 'brakeman',   '~> 1.9.5', require: false
  gem 'xray-rails', '~> 0.1.4'
  gem 'ruby-prof',  '~> 0.13.0' # profiling with /newrelic

  gem 'capistrano',         '~> 2.15.4'
  gem 'capistrano_colors',  '~> 0.5.5'
  gem 'term-ansicolor',     '~> 1.1.5'
  gem 'hirb',               '~> 0.7.0'
  gem 'wirble',             '~> 0.1.3'

  gem 'guard-rspec',  '~> 2.6.0'
  gem 'guard-spork',  '~> 1.5.0'

  gem 'spork-rails',  '~> 3.2.0'

  # Pry: IRB + ruby debug alternative which is active and easier to install
  gem 'pry-remote',    '~> 0.1.7' # Needed for using pry in spork
  gem 'pry-rails',     '~> 0.2.2'
  gem 'pry-debugger',  '~> 0.2.2'
  gem 'pry-coolline',  '~> 0.2.2'

  gem 'better_errors',      '~> 0.8.0'
  gem 'binding_of_caller',  '~> 0.7.1'
  gem 'quiet_assets',       '~> 1.0.2'
  gem 'meta_request',       '~> 0.2.3'

  gem 'webrick',  '~> 1.3.1' # Included explicitly so #chunked warnings no longer show up in the dev log
end

group :test do
  gem 'fabrication',       '~> 2.7.0'
  gem 'database_cleaner',  '~> 0.9.1'
  gem 'therubyracer',      '~> 0.11.4' # embeded JS interpreter for our CI server

  gem 'capybara',  '~> 2.1.0'
  gem 'launchy',   '~> 2.2.0'

  gem 'fuubar',  '~> 1.1.0'

  gem 'cucumber-rails',  '~> 1.3.1',  require: false

  gem 'bundler-audit', '~> 0.1.2'
end

group :staging do
  gem 'mail_safe',  '~> 0.3.1'
end

group :development, :test do
  gem 'rspec-rails',  '~> 2.13.1'
  gem 'guard',        '~> 1.8.0'
  gem 'listen',       '~> 1.0.3'

  gem 'letter_opener',  '~> 1.1.0'

  gem 'simplecov',  require: false
end

group :development, :staging do
  gem 'oink',  '~> 0.10.1',  require: 'oink'
end

group :development, :test, :staging do
  gem 'delorean',  '~> 2.1.0'
end

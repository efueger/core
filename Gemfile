source "https://rubygems.org"

if RUBY_VERSION != "2.1.6"
  warn "WARNING: You are not running the version of Ruby targeted for this application (#{RUBY_VERSION} != 2.1.6)."
end

group :default do # XXX: all environments, think twice before adding Gems here
  gem "rake",                            "~> 10.3.2" # i18n-spec breaks with 10.4 :/
  gem "rails",                           "< 4"
  gem "rails-i18n",                      "~> 3.0.0" # For Rails 3.x
  gem "pg"
  gem "haml-rails"
  gem "jquery-rails"
  gem "jquery-ui-rails"
  gem "bootstrap-sass",                  "< 3"
  gem "bootbox-rails"
  gem "select2-rails"
  gem "devise"
  gem "devise-i18n"
  gem "simple_form",                     "< 3"
  gem "inherited_resources"
  gem "mini_magick"
  gem "carrierwave"
  gem "acts-as-taggable-on"
  gem "pg_search"
  gem "whenever"
  gem "acts_as_list"
  gem "default_value_for"
  gem "fuzzy-string-match", require: "fuzzystringmatch"
  gem "state_machine"
  gem "figaro"
  gem "virtus"
  gem "draper"
  gem "naught"
  gem "premailer-rails"
  gem "nokogiri" # premailer-rails dependency
  gem "delayed_job",                     "< 4"
  gem "delayed_job_active_record"
  gem "delayed_job_web",                 "= 1.2.0" # version hardcoded in config/deploy.rb
  gem "daemons" # able to monitor delayed_job via monit
  gem "analytical"
  gem "ace-rails-ap"
  gem "active_utils",                    "< 3" # uninitialized constant ActiveMerchant::Billing::CreditCard::Validateable
  gem "activemerchant"
  gem "attr_encryptor"
  gem "countries", require: "iso3166"
  gem "country_select"
  gem "biggs"
  gem "charlock_holmes"
  gem "rabl"
  gem "apipie-rails"
  gem "strong_parameters"
  gem "rails-timeago"
  gem "discover-unused-partials"
  gem "rack-mini-profiler"
  gem "fast_blank"
  gem "retryable"
  gem "foreman"
  gem "rails-patch-json-encode"
  gem "oj"
  gem "intercom-rails"
  gem "intercom"
  gem "crazy_money"
  gem "currency_data"
  gem "email_templator"
  gem "simple_form-bank_account_number"
  gem "ordinalize_full", require: "ordinalize_full/integer"
  gem "librato-rails"
  gem "rbtrace"
  gem "geokit", require: false
end

group :development do
  gem "webrick" # Included explicitly so #chunked warnings no longer show up in the dev log
  gem "yard",       require: false
  gem "bullet",     require: false
  gem "brakeman",   require: false
  gem "xray-rails", require: false
  gem "ruby-prof",  require: false # profiling with /newrelic
  gem "capistrano", "~> 2" # v3 is broken with `undefined local variable or method `tasks_without_stage_dependency"` atm
  gem "term-ansicolor"
  gem "parallel_tests"
  gem "sextant"
  gem "better_errors"
  gem "binding_of_caller"
  gem "quiet_assets"
  gem "meta_request"
  gem "i15r", require: false
end

group :test do
  gem "fabrication", "~> 2.9.8" # TODO upgrade and fix broken specs
  gem "database_cleaner"
  gem "therubyracer", require: false # embeded JS interpreter for our CI server
  gem "simplecov", require: false
  gem "cucumber-rails", require: false
  gem "capybara", "~> 2.3.0", require: false # TODO: fix cukes for 2.4
  gem "capybara-screenshot"
  gem "poltergeist", require: false
  gem "launchy"
  gem "guard-rspec"
  gem "rspec-activemodel-mocks"
  gem "i18n-spec", require: false
end

group :staging do
  gem "mail_safe"
  # gem "oink"
end

group :staging, :production do
  gem "newrelic_rpm"
  gem "bugsnag"
  gem "skylight"
end

group :development, :staging do
  # gem "stackprof", git: "https://github.com/tmm1/stackprof.git"
end

group :development, :test do
  gem "rspec-rails"
  gem "listen"
  gem "terminal-notifier-guard" # Mac 10.8 system notifications for Guard
  gem "letter_opener"
  gem "bundler-audit", require: false
  gem "rubocop"
  gem "byebug"
  gem "cane"
  gem "pry-byebug"
  gem "pry-rails"
  gem "pry-coolline" # as-you-type syntax highlighting
  gem "pry-stack_explorer"
end

group :development, :test, :staging do
  gem "delorean"
end

group :assets do
  gem "coffee-rails"
  gem "uglifier"
  gem "sass-rails"
  gem "compass-rails"
end

group :install do
  gem "sprinkle",  git: "https://github.com/jordandcarter/sprinkle.git" # patched to be awesome.. added more verifiers and updated some installers
end


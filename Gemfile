source "https://rubygems.org"

ruby "4.0.6"

gem "rails", "~> 8.1.3"
gem "puma", "~> 8.0"
gem "bootsnap", "~> 1.24", require: false

# RailsAdmin 3 supports Sprockets directly and the application extends its
# asset bundle with project-specific admin behavior and styling.
gem "sprockets-rails", "~> 3.5"
gem "sassc-rails", "~> 2.1"

gem "config", "~> 5.6"
gem "date_validator", "~> 0.12"
gem "devise", "~> 5.0"
gem "discourse_api", "~> 2.1"
gem "dotenv-rails", "~> 3.2"
gem "fog-aws", "~> 3.33"
gem "carrierwave", "~> 3.1"
gem "mini_magick", "~> 5.3"
gem "net-ssh", "~> 7.3"
gem "oj", "~> 3.17"
gem "pg", "~> 1.6"
gem "pundit", "~> 2.5"
gem "rabl", "~> 0.17"
gem "rack-cors", "~> 3.0"
gem "rails_admin", "~> 3.3"
gem "recursive-open-struct", "~> 2.1"
gem "responders", "~> 3.2"
gem "sentry-rails", "~> 6.6"

group :development do
  gem "better_errors", "~> 2.10"
  gem "binding_of_caller", "~> 1.0"
  gem "debug", "~> 1.11"
end

group :development, :test do
  gem "brakeman", "~> 7.1", require: false
  gem "bundler-audit", "~> 0.9", require: false
  gem "factory_bot_rails", "~> 6.5"
  gem "pry-rails", "~> 0.3"
  gem "rspec-rails", "~> 8.0"
  gem "simplecov", "~> 1.0", require: false
end

group :test do
  gem "database_cleaner-active_record", "~> 2.2"
  gem "faker", "~> 3.8"
  gem "vcr", "~> 6.4", require: false
end

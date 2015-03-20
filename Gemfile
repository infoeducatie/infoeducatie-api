# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
source 'https://rubygems.org'
ruby '2.2.0'
gem 'rails', '4.2.0'

gem 'dotenv-rails'

# JSON building and parsing
gem 'rabl', '~> 0.9.0'
gem 'oj'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'unicorn'
gem 'unicorn-rails'

gem 'devise', '~> 3.4.0'
gem 'rails_admin', '~> 0.6.7'
gem 'pg'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'factory_girl_rails', "~> 4.0"
  gem 'faker', "~> 1.4.1"
  gem "database_cleaner", "~> 1.2.0"
  gem 'vcr', require: false
end

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'guard-rspec', require: false
  gem 'simplecov', require: false
  gem 'mysql2'
  gem 'sqlite3'
  gem 'pry-rails'
end

# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Rails version
gem 'rails', '~> 5.2.1'

# main gems
gem 'bootsnap', '>= 1.1.0', require: false
gem 'dry-monads'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rack-cors', require: 'rack/cors'

# grape + jsonapi
gem 'grape'
gem 'grape-middleware-logger'
gem 'grape-swagger'
gem 'grape-swagger-entity'
gem 'grape-swagger-rails'
gem 'grape-swagger-representable'
gem 'hashie-forbidden_attributes' # to make grape params validation work
gem 'jsonapi-rb'

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.8'
end

group :test do
  # shoulda-matchers master branch for Rails5 support
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers'
  gem 'timecop', '~> 0.9.1'
end

group :development do
  gem 'better_errors'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

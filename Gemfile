source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# React on Rails with Shakapacker for React frontend
gem "react_on_rails", "~> 16.0"
gem "shakapacker", "~> 9.5"

# GraphQL API
gem "graphql", "~> 2.6"

# Authentication & Authorization
gem "devise", "~> 5.0"
gem "pundit", "~> 2.4"

# Materialized views
gem "scenic", "~> 1.8"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "pry"
  gem "pry-byebug"
  gem "pry-rails"

  # Testing
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
gem "graphiql-rails", group: :development

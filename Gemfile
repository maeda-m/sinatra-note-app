# frozen_string_literal: true

source 'https://rubygems.org'

gem 'pg'
gem 'puma'
gem 'sinatra'

group :development do
  gem 'rubocop', '~> 1.26', require: false
  # See: https://github.com/fjordllc/rubocop-fjord
  gem 'rubocop-fjord', require: false
  # See: https://github.com/rubocop/rubocop-minitest
  gem 'rubocop-minitest', require: false

  gem 'debug'
end

group :test do
  gem 'rack-test'
end

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use sqlite3 as the database for Active Record
gem 'sass-rails', '5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.2.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.2.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '5.0.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.7.0'
# Use Redis adapter to run Action Cable in production
gem 'jquery-rails', '4.3.1'
gem 'bootstrap-sass', '3.3.7'
gem 'bcrypt', '3.1.12'
gem 'faker', '1.7.3'
gem 'carrierwave', '1.2.2'
gem 'mini_magick', '4.7.0'
gem 'will_paginate', '3.1.6'
gem 'bootstrap-will_paginate', '1.0.0'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '9.0.6', platforms: :mri
  gem 'sqlite3', '1.3.13'
end

group :development do
  gem 'web-console', '3.5.1'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  #gem 'web-console', '>= 3.3.0'
  gem 'listen', '3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  #gem 'capybara', '>= 2.15'
  #gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  #gem 'chromedriver-helper'
  gem 'minitest', '5.10.3'
  gem 'minitest-reporters', '1.1.14'

  gem 'guard', '2.14.1'
  gem 'guard-minitest', '2.4.6'
  gem 'rails-controller-testing', '1.0.2'
end

group :production do
  gem 'pg', '~>0.20.0'
  gem 'fog', '1.42'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

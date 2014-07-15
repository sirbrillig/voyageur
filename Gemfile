source 'https://rubygems.org'

gem 'rails', '3.2.11'

group :assets do
  gem 'sass-rails', '~> 3.2.3'
  gem 'react-rails', '~> 0.10.0.0'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-rails'
  gem 'execjs'
end

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

gem 'haml'
gem 'haml-rails'

gem 'bootstrap-sass',
  git: 'https://github.com/twbs/bootstrap-sass',
  ref: '540ad23430b1bdb2c72591daf61507ec9e38e468'
gem 'bootstrap-generators', '~> 2.1'
gem 'simple_form'

gem 'acts_as_list'

gem 'devise'

gem 'thin'

gem 'audited-activerecord', '~> 3.0'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'selenium-webdriver'
  gem 'konacha'
  gem 'sinon-rails'
  gem 'phantomjs'
end

# group :development do
#   gem 'rb-fsevent', '~> 0.9'
#   gem 'guard'
#   gem 'guard-livereload'
#   gem 'rack-livereload'
# end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end

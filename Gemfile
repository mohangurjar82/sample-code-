source 'https://rubygems.org'

ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'oj'
gem 'thread', require: 'thread/pool'
gem 'concurrent-ruby'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'activeadmin', '~> 1.0.0.pre2'
gem 'active_admin_flat_skin'

gem 'devise'
gem 'immutable-struct'
gem 'puma'
gem 'rails_12factor', group: :production
gem 'slim-rails'

gem 'httparty'
gem 'tpdata', require: 'theplatform'

gem 'font-awesome-rails'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sweet-alert-confirm'

source 'https://rails-assets.org' do
  gem 'rails-assets-sweetalert'
end

group :development, :test do
  gem 'pry'
  gem 'byebug'
  gem 'quiet_assets'
  gem 'dotenv-rails'
  gem 'guard-foreman'
  gem 'guard-rspec', require: false
  gem 'rspec-rails'
end

group :test do
  gem 'factory_girl_rails'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end


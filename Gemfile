source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
#gem 'bcrypt', '~> 3.1.11'
gem 'bcrypt', '3.1.11', platforms: [:ruby, :x64_mingw, :mingw]

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development

gem 'slim-rails'
gem 'devise'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'skim'
gem 'gon'
gem 'responders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'faker'
gem 'cancancan'
#gem 'pundit'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'rails-controller-testing'
  gem 'launchy'
  #gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'capybara-webkit'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'orderly'
  gem 'json_spec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'sprockets' 
# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'
gem 'will_paginate', '~> 3.0.0'
# Asset template engines
gem 'sass-rails' #, :git => 'https://github.com/rails/sass-rails.git'
gem 'coffee-script'
gem 'uglifier'
gem 'therubyracer'
gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :production do
  gem 'pg'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
end
gem "rspec-rails", :group => [:test, :development]
group :test do
  gem "factory_girl_rails"
  gem 'capybara', git: 'git://github.com/jnicklas/capybara.git'
  gem "guard-rspec"
  gem "launchy"
  gem "database_cleaner"
end

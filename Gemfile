source 'http://rubygems.org'

gem 'rails', '3.1.0.rc5'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Asset template engines
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'
gem 'uglifier'
gem 'jquery-rails'
gem 'therubyracer'
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  gem "factory_girl_rails"
  gem 'capybara', git: 'git://github.com/jnicklas/capybara.git'
  gem "launchy"
  gem 'database_cleaner'
  gem 'turn', :require => false
end

group :production do
  gem 'pg'
end
group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
end

source 'https://rubygems.org'
ruby '2.4.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.10'

# Use Postgres as the database for Active Record
gem 'pg', '~> 0.15.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.12'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.7'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '~> 3.2.0'

# Use Slim for templates
gem 'slim-rails'

# Use administrate for our admin section
gem 'administrate'

# Use Twilio for verification SMS
gem 'twilio-ruby'

group :development, :test do

  # Use .env file for local configuration
  gem 'dotenv-rails'

  # Use Rspec instead of Test::Unit
  gem 'rspec-rails'

  # Use Capybara for better view specs
  gem 'capybara'

  # Use Factory Girl for database fixtures
  gem 'factory_bot_rails'

end

group :development do

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Use Pry for simpler debugging
  gem 'pry'

  # Access an IRB console on exception pages or by using <%%= console %> in views
  gem 'web-console', '~> 2.0.0'

end

group :production do

  # Use Puma as the app server
  gem 'puma', '~> 3.11.4'

  # Use 12Factor to log to stdout and serve static assets directly
  gem 'rails_12factor'

end

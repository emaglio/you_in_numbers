source 'https://rubygems.org'

ruby '2.5.3'

gem 'rails', '~> 5.2.1'

gem 'puma', '~> 3.12'
gem 'early', '~> 0.3'

# front-end
gem 'webpacker', '~> 5.x'

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails', '~> 4.4'
gem 'sass-rails', '~> 5.0'
gem 'pg', '~> 1.2'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'slim-rails', '~> 3.2'
gem 'cells-rails', '~> 0.1'
gem 'cells-slim', '~> 0.1'
gem 'dry-validation', '~> 0.13.3'
gem 'file_validators', '~> 2.3'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'formular', git: 'https://github.com/trailblazer/formular.git', branch: 'master'
gem 'trailblazer', '~> 2.1'
gem 'trailblazer-cells', '~> 0.0'
gem 'trailblazer-rails', '~> 2.0'
# gem 'tyrant', git: 'https://github.com/emaglio/tyrant.git', branch: 'trb-2_1'
gem 'tyrant', :path => '../tyrant'
gem 'reform', '>= 2.3.0.rc1'
gem 'reform-rails', '>= 0.2.0.rc1'

# excel-csv file elaboration
gem 'roo', '~> 2.7.0'

# email and image processing
gem 'paperdragon', '~> 0.0'
gem 'pony', '~> 1.13'

# pdf generation
gem 'prawn', '~> 2.3'
gem 'prawn-table', '~> 0.2'

# waiting bar
gem 'nprogress-rails', '~> 0.2.0'

gem 'omniauth', '~> 1.9'
gem 'omniauth-github', '~> 1.4'

# locale
gem 'rails-i18n', '~> 5.0'

group :development do
  gem 'better_errors', '~> 2.8'
  gem 'web-console', '~> 2.0'
  gem 'spring', '~> 2.1'
  gem 'rubocop', '~> 0.92', require: false
  gem 'rubocop-performance', '~> 1.8', require: false
  gem 'rubocop-rails', '~> 2.8', require: false
  gem 'rack-mini-profiler', '~> 2.3.0'
  gem 'memory_profiler', '~> 1.0.0'
end

group :test do
  gem 'capybara', '~> 3.35'
  gem 'capybara-email', '~> 3.0'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'capybara-slow_finder_errors', '~> 0.1'
  gem 'codecov', '~> 0.2', require: false
  gem 'database_cleaner', '~> 1.8'
  gem 'factory_bot_rails', '~> 6.1'
  gem 'faker', '~> 2.16'
  gem 'minitest-bang', '~> 1.0'
  gem 'minitest-line', '~> 0.6'
  gem 'minitest-rails-capybara', '~> 3.0'
  gem 'simplecov', '~> 0.19', require: false
  gem 'trailblazer-test', '~> 0.1'
end

group :development, :test do
  gem 'pry-rails', '~> 0.3.9'
  gem 'pry-byebug', '~> 3.9.0'
end

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'dotenv-rails', groups: [:development, :test]
gem 'rails',    '~> 6.0.2', '>= 6.0.2.1'
gem 'pg',       '>= 0.18', '< 2.0'
gem 'puma',     '>= 4.3.3'
gem 'faker',    '~> 1.6', '>= 1.6.3'
gem 'bcrypt',   '~> 3.1.7'
gem 'rack-cors'
gem 'jwt',      '~> 2.2', '>= 2.2.1'
gem 'jbuilder', '~> 2.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

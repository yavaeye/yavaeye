source :rubygems

gem 'rack-flash'
gem 'slim'
gem 'sinatra'
gem 'bcrypt-ruby', require: "bcrypt"
gem 'activesupport', require: "active_support/core_ext"
gem 'bson_ext'
gem 'mongoid'
gem 'mongoid_token'

group :production do
  gem 'unicorn'
end

group :test do
  gem 'rack-test'
  gem 'factory_girl'
end

group :development, :test do
  gem 'rack-coffee', require: 'rack/coffee'
  gem 'coffee-script'
end

group :development do
  gem 'socksify', git: "git://github.com/luikore/socksify-ruby.git"
end

group :deployment do
  gem 'capistrano'
  gem 'compass'
end
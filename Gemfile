source :rubygems

gem 'rack-flash'
gem 'slim'
gem 'sinatra'
gem 'bcrypt-ruby'
gem 'activesupport'
gem 'bson_ext'
gem 'mongoid'
gem 'mongoid_token'

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem 'rack-coffee', require: 'rack/coffee'
  gem 'sinatra-reloader'
  gem 'coffee-script'
  gem 'compass'
  gem 'socksify', git: "git://github.com/luikore/socksify-ruby.git"
  gem 'rack-test'
  gem 'factory_girl'
  gem 'capistrano'
end

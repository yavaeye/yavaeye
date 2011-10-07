source :rubygems

gem 'slim'
gem 'sinatra', '~> 1.3.0'
gem 'sinatra-flash'
gem 'sinatra-contrib', '~> 1.3.0'
gem 'bcrypt-ruby'
gem 'activesupport'
gem 'bson_ext'
gem 'mongoid'
gem 'mongoid_token', git: "git://github.com/thetron/mongoid_token.git"
gem 'ruby-openid'

group :production do
  gem 'unicorn'
end

group :development, :test do
  gem 'compass'
  gem 'socksify', git: "git://github.com/luikore/socksify-ruby.git"
  gem 'rack-test'
  gem 'factory_girl'
  gem 'capistrano'
  gem 'ruby-debug19'
  gem 'simplecov'
end

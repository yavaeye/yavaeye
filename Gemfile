source :rubygems

gem "slim"
gem "sinatra", "~> 1.3.0"
gem "sinatra-flash", require: "sinatra/flash"
gem "sinatra-contrib", "~> 1.3.0", require: "sinatra/contrib/all"
gem "bcrypt-ruby", require: "bcrypt"
gem "activesupport", require: "active_support/core_ext"
gem "bson_ext", "~> 1.4.0"
gem "mongoid", "~> 2.3.3"
gem "mongoid_token", git: "git://github.com/thetron/mongoid_token.git"
gem "ruby-openid", require: "openid"
gem "oauth2", "~> 0.5.1"

group :production do
  gem "unicorn"
end

group :development, :test do
  gem "compass"
  gem "socksify", git: "git://github.com/luikore/socksify-ruby.git", require: "socksify/http"
  gem "rack-test"
  gem "factory_girl"
  gem "capistrano"
  gem "simplecov"
  gem "pry"
  gem "nokogiri"
end

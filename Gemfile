source :rubygems

gem "slim"
gem "pony"
gem "oauth2"
gem "coderay"
gem "sinatra"
gem "redcarpet"
gem "sinatra-contrib"
gem "sinatra-flash"
gem "sprockets"
gem "sprockets-helpers"
gem "ruby-readability", require: 'readability'
gem "bcrypt-ruby", require: 'bcrypt'

# activerecord 4 with postgres hstore support !
git "git://github.com/rails/rails.git" do
  gem "activerecord", require: 'active_record'
end
gem "active_record_deprecated_finders", git: "git://github.com/rails/active_record_deprecated_finders.git"
gem "pg"

group :development, :test do
  gem "pry"
  gem "sass"
  gem "compass"
  gem "sprockets-sass"
  gem "coffee-script"
  gem "uglifier"
  gem "capistrano"
end

group :production do
  gem "thin"
end

group :test do
  gem "rack-test"
  gem "factory_girl"
  gem "database_cleaner"
  gem "simplecov", require: false
end

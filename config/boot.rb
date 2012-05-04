require "rubygems"
require "bundler"
require "yaml"

# require "bundle gems"
ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

# init database
require_relative "database.rb"

# init sinatra
set :sessions, true
set :session_secret, "33929a92388e209c848519ac6dff0c2e"
set :root, File.expand_path(".")
set :views, settings.root + "/app/views"

# sinatra reloader
if development?
  require "sinatra/reloader"
  also_reload "lib/**/*.rb", "app/{models,helpers}/**/*.rb"
end

# assets
require "sprockets/sass/functions"
require settings.root + "/config/assets.rb"
use Assets::Middleware if development?

# require project files
Dir.glob "./{lib,app/models,app/helpers,app/controllers}/**/*.rb" do |f|
  require f
end

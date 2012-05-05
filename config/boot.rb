#! /usr/bin/env ruby

require "bundler"
require "yaml"

# require "bundle gems"
ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

# init database
require_relative "database"

# init sinatra
set :sessions, true
require_relative "secret"
set :root, File.expand_path(".")
set :views, settings.root + "/app/views"

# sinatra reloader
if development?
  require "sinatra/reloader"
  also_reload "lib/**/*.rb", "app/{models,helpers}/**/*.rb"
end

# csrf
require_relative "csrf_protection"
use Rack::CsrfProtection unless test?

# assets
require "sprockets/sass/functions" if development?
require settings.root + "/config/assets.rb"
use Assets::Middleware if development?

# oauth app token
set :github, YAML::load_file(settings.root + '/config/oauth.yml')['github']
set :google, YAML::load_file(settings.root + '/config/oauth.yml')['google']

# require project files
Dir.glob "./{lib,app/models,app/helpers,app/controllers}/**/*.rb" do |f|
  require f
end

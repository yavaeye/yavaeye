#! /usr/bin/env ruby

require "bundler"
require "yaml"

# require "bundle gems"
ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

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

# oauth app
set :oauth, YAML::load_file(settings.root + '/config/oauth.yml')
set :github_oauth_client, OAuth2::Client.new(settings.oauth["github"]["id"], settings.oauth["github"]["secret"],
                                             :site => "https://github.com",
                                             :authorize_url => "/login/oauth/authorize",
                                             :token_url => "/login/oauth/access_token")
set :google_oauth_client, OAuth2::Client.new(settings.oauth["google"]["id"], settings.oauth["google"]["secret"],
                                             :site => "https://accounts.google.com",
                                             :authorize_url => "/o/oauth2/auth",
                                             :token_url => "/o/oauth2/token")

# init database
ActiveRecord::Base.establish_connection YAML.load_file(settings.root + '/config/database.yml')[ENV['RACK_ENV'].to_s]

# require project files
# Dir.glob "./{lib,app/models,app/helpers,app/controllers}/**/*.rb" do |f|
#   require f
# end

require "fileutils"

FileUtils.cd File.dirname File.dirname __FILE__

require "bundler"
ENV['RACK_ENV'] ||= 'development'
Bundler.setup ENV['RACK_ENV'].to_sym
Bundler.require
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/contrib'
require 'slim'
require 'bcrypt'
require 'active_support/core_ext'
require 'mongoid'
require 'mongoid_token'

require_relative 'database'
require "./lib/secret"

set :root, File.expand_path('.')
set :views, settings.root + '/app/views'
set :method_override, true # allow _method=put, _method=delete params

set :sessions, true

respond_to :html, :xml, :json

use Rack::Session::Cookie,
  key: 'rack.session',
  domain: (ENV['RACK_ENV'] =~ /development|test/ ? nil : 'yavaeye.com'),
  path: '/',
  expire_after: 1800, # seconds
  secret: Secret.session_secret,
  httponly: true

# csrf
use Rack::Protection::FormToken

configure :development do
  require "./script/asset"
  $asset = Asset.new
  before { $asset.compile }
  require "sinatra/reloader"
end

configure :test do
  require 'minitest/autorun'
  require "factory_girl"
end

Dir.glob "./{lib,app/models,app/helpers,app/controllers}/*.rb" do |f|
  require f
end


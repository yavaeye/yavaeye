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
require "openid"

require_relative 'database'
require "./lib/secret"
Secret.init
set :root, File.expand_path('.')
set :views, settings.root + '/app/views'
set :method_override, true # allow _method=put, _method=delete params

set :sessions, true

use Rack::Session::Cookie,
  key: 'rack.session',
  domain: (ENV['RACK_ENV'] =~ /development|test/ ? nil : 'yavaeye.com'),
  path: '/',
  expire_after: 1800, # seconds
  secret: Secret.session_secret,
  httponly: true

# csrf
use Rack::Protection::FormToken

configure do
  mime_type :html, 'text/*'
  mime_type :html, '*'
  mime_type :html, '*/*'
end

configure :development do
  require "./script/asset"
  # proxy for openid
  if port = ENV['openid_proxy_port']
    puts "=> Using proxy for openid request"
    require 'socksify/http'
    proxy = Net::HTTP.SOCKSProxy '127.0.0.1', port.to_i
    OpenID.fetcher.instance_variable_set :@proxy, proxy
  end
  $asset = Asset.new
  before { $asset.compile }
  require "sinatra/reloader"
end

Dir.glob "./{lib,app/models,app/helpers,app/controllers}/*.rb" do |f|
  require f
end

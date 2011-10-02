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
require 'rmmseg'

set :sessions, true
use Rack::Session::Cookie

configure :development do
  require "./script/asset"
  $asset = Asset.new
  before { $asset.compile }
  require "sinatra/reloader"
end

Dir.glob "./{lib,app/models,app/helpers,app/controllers}/*.rb" do |f|
  require f
end


require "fileutils"

FileUtils.cd File.dirname File.dirname __FILE__

require "bundler"
Bundler.setup (ENV['RACK_ENV'] || :development).to_sym
Bundler.require
require 'sinatra'
require 'rack-flash'
require 'slim'
require "bcrypt"
require "active_support/core_ext"
require 'mongoid'
require 'mongoid_token'

Dir.glob "./{lib,app/models,app/controllers}/*.rb" do |f|
  require f
end

configure :development do |c|
  require "sinatra/reloader"
  c.also_reload "./lib/*.rb"
  c.also_reload "./app/models/*.rb"
  c.also_reload "./app/controllers/*.rb"

  require 'compass'
  Compass.configuration do |c|
    c.project_path = '.'
    c.sass_dir = 'sass'
  end

  set :sass, Compass.sass_engine_options
end

set :sessions, true


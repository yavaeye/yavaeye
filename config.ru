# encoding: UTF-8

require "bundler"
Bundler.setup(ENV['RACK_ENV'] || :development)

require "./config/boot.rb"
run Sinatra::Application

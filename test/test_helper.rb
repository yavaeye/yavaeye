begin
  ENV["RACK_ENV"] = 'test'
  require_relative "../config/boot.rb"
  # set :sessions, false

  require "ruby-debug"
  require "factory_girl"
  require 'minitest/autorun'

  dir = File.expand_path File.dirname(__FILE__)
  Dir.glob "#{dir}/factory/**/*_factory.rb" do |f|
    require f
  end
end

class TestCase < MiniTest::Unit::TestCase
  def initialize *xs
    super
    # clean test db before every case
    (Mongoid.database.collection_names - %w[system.indexes]).each do |c|
      Mongoid.database.drop_collection c
    end
  end
end

class FunctionalTestCase < TestCase
  include Sinatra::TestHelpers
  def app
    Sinatra::Application
  end

  %w[get post put delete].each do |verb|
    class_eval <<-RUBY
    def #{verb} path, params={}, options={}
      options = options.stringify_keys
      options['HTTP_X_REQUESTED_WITH'] = "XMLHttpRequest" if options.delete 'xhr'
      options['HTTP_ACCEPT'] = options.delete('accept') || "text/html"
      super(path, params, options)
    end
    RUBY
  end

end
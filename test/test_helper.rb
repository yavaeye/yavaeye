begin
  ENV["RACK_ENV"] = 'test'

  require_relative "../config/boot.rb"

  if $coverage
    # https://github.com/colszowka/simplecov
    SimpleCov.start 'rails'
  end

  set :sessions, false

  require 'minitest/autorun'

  require_relative "factory/factories.rb"

  # make sure admin initialized in test database
  Secret.admin_password = 'admin'
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

  # select css in response
  def css selector
    s = body
    if s.empty?
      raise 'Response has no body'
    else
      @body_dom ||= Nokogiri.HTML(s)
      @body_dom.css selector
    end
  end

  def assert_select selector
    assert css(selector).present?, "selector not found: #{selector.inspect}"
  end
end

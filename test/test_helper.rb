begin
  ENV["RACK_ENV"] = 'test'

  if $coverage
    # https://github.com/colszowka/simplecov
    # NOTE only lines after loading simplecov can be verified
    require "simplecov"
    SimpleCov.start 'rails'
  end

  require_relative "../config/boot.rb"

  set :sessions, false

  require 'minitest/autorun'

  require_relative "factory/factories.rb"

  # make sure admin initialized in test database
  Secret.admin_password = 'admin'
end

# when testing, protection middleware is disabled by default
class Rack::YavaProtection
  alias _call call

  def self.disable
    def call env; app.call env; end
  end

  def self.enable
    alias call _call
  end

  disable
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
      def #{verb} path, params={}, options=@env
        options = (options || {}).stringify_keys
        options['HTTP_X_REQUESTED_WITH'] = "XMLHttpRequest" if options.delete 'xhr'
        options['HTTP_ACCEPT'] = options.delete('accept') || "text/html"
        super(path, params, options)
      end
    RUBY
  end

  def login
    @user = Factory(:user)
    # NOTE DO NOT even try to use with_indifferent_access, will surely fail
    @env ||= {}
    @env['rack.session'] ||= {} # trap: session is not the same hash
    @env['rack.session'].merge! 'user_id' => @user.id.to_s
  end

  # NOTE should always use string keys in testing (symbol keys in application is ok)
  def session
    @env ||= {}
    @env['rack.session'] ||= {}
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

  # similar to rails test helper assert_select
  def assert_select selector, have=true
    if have
      assert css(selector).present?, "selector not found: #{selector.inspect}"
    else
      assert css(selector).blank?, "selector should not be found: #{selector.inspect}"
    end
  end
end

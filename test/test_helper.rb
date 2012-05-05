ENV['RACK_ENV'] ||= "test"

if $coverage
  # https://github.com/colszowka/simplecov
  # NOTE only lines after loading simplecov can be verified
  require "simplecov"
  SimpleCov.start 'rails'
  SimpleCov.command_name 'Unit Tests'
end

require_relative "../config/boot.rb"

# factory_girl
dir = File.expand_path File.dirname(__FILE__)
require_relative "factory/factories.rb"

require "minitest/autorun"
require "rack/test"
DatabaseCleaner.strategy = :truncation

class TestCase < MiniTest::Unit::TestCase
  include FactoryGirl::Syntax::Methods
  def initialize *xs
    super
    DatabaseCleaner.clean
  end
end

class FunctionalTestCase < TestCase
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

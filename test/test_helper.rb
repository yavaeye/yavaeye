require 'test/unit'
require 'factory_girl'

begin

  ENV["RACK_ENV"] = 'test'
  require_relative "../config/boot.rb"

  dir = File.expand_path File.dirname(__FILE__)
  Dir.glob "#{dir}/factory/**/*_factory.rb" do |f|
    require f
  end
end


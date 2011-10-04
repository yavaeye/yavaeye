begin
  ENV["RACK_ENV"] = 'test'
  require_relative "../config/boot.rb"

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


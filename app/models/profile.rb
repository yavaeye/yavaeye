class Profile < ActiveRecord::Base
  include Hstore

  has_one :user
end

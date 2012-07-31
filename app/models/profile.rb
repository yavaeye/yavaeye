class Profile < ActiveRecord::Base
  include ActiveRecord::Hstore

  has_one :user
end

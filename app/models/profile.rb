class Profile < ActiveRecord::Base
  include Hstore

  belongs_to :user
end

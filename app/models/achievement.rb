class Achievement
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :badge

  belongs_to :user

  validates_uniqueness_of :name
  validates_length_of :name, minimum: 2, maximum: 32
end


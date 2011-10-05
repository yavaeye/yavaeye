class Achievement
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :badge

  belongs_to :user

  validates_uniqueness_of :badge, :user
  validates_length_of :badge, minimum: 2, maximum: 32
end


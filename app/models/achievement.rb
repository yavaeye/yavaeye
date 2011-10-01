class Achievement
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name
  field :winners_count, type: Integer, default: 0

  belongs_to :user

  validates_uniqueness_of :name
  validates_length_of :name, minimum: 2, maximum: 32
end


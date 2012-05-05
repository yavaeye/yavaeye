class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name

  has_and_belongs_to_many :posts

  validates_presence_of :name
  validates_length_of :name, maximum: 32
end

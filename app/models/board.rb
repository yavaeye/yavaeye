class Board
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :slug
  field :name
  field :founder
  field :description
  field :unsubscribe_count, type: Integer, default: 0
  field :active, type: Boolean, default: false

  validates_uniqueness_of :slug
  validates_presence_of :slug, :name, :founder, :description
  validates_length_of :slug, maximum: 16
  validates_length_of :name, maximum: 16
  validates_length_of :description, maximum: 1024

end


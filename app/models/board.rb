class Board
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :slug
  field :name
  field :description
  field :active, type: Boolean, default: false

  has_many :posts
  belongs_to :user

  validates_uniqueness_of :slug
  validates_presence_of :slug, :name, :description
  validates_length_of :slug, maximum: 16
  validates_length_of :name, maximum: 16
  validates_length_of :description, maximum: 1024

  after_create do
    #TODO notification
  end

  after_update do
    #TODO notification
  end
end


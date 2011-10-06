class Board
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name
  field :description
  field :active, type: Boolean, default: false

  default_scope where(active: true)

  has_many :posts
  belongs_to :user

  validates_uniqueness_of :name
  validates_presence_of :name, :description, :user
  validates_length_of :name, maximum: 16
  validates_length_of :description, maximum: 1024

  before_update do
    if active_changed? and active
      user.inc(:karma, 10)
      Mention.new(type: "founder", event: _id, text: "board").deliver
    end
  end

  after_destroy do
    user.inc(:karma, -10)
  end

  def self.find_by_name name
    where(name: name).first
  end
end


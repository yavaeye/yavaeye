class Mention
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Paginate

  field :text
  field :type
  field :event
  field :triggers, type: Array, default: []
  field :read, type: Boolean, default: false

  scope :unread, where(read: false)

  belongs_to :user

  validates_presence_of :user
  validates_length_of :text, maximum: 10240
end

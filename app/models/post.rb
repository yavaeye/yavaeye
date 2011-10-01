class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Token

  field :title
  field :link
  field :content
  field :user_id
  field :user_nick
  field :board_slug
  field :board_name
  field :segments, type: Array, default: []
  field :comment_count, type: Integer, default: 0

  token :length => 5, :contains => :alphanumeric

  has_many :comments

  validates_presence_of :title
  validates_length_of :title, maximum: 128
  validates_length_of :content, maximum: 10240
end


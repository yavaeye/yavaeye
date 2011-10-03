class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paginate
  include Mongoid::Paranoia
  include Mongoid::Token

  field :title
  field :link
  field :content
  field :user_nick
  field :board_slug
  field :board_name
  field :segments, type: Array, default: []
  field :comment_count, type: Integer, default: 0

  token :length => 5, :contains => :alphanumeric

  belongs_to :user
  belongs_to :board
  has_many :comments

  validates_presence_of :title
  validates_length_of :title, maximum: 128
  validates_length_of :content, maximum: 10240

  before_save do
    self.segments = Seg.segment title
  end

end


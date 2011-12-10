# encoding: UTF-8

class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paginate
  include Mongoid::Paranoia
  include Mongoid::Token

  field :title
  field :link
  field :content
  field :domain
  field :score, type: Float, default: 0.0
  field :marks, type: Array, default: []
  field :dislikes, type: Array, default: []
  field :segments, type: Array, default: []

  token :length => 5, :contains => :alphanumeric

  belongs_to :user
  belongs_to :board
  has_many :comments

  validates_presence_of :title, :board, :user
  validates_length_of :title, maximum: 128
  validates_length_of :content, maximum: 10240
  validates_format_of :link, with: /\A#{URI::regexp}\Z/, if: ->{ link.present? }

  validate do
    unless link.blank? ^ content.blank?
      errors.add :base, 'link or content has some problems'
    end
  end

  before_save :generate_domain, :calculate_score

  after_create do
    user.inc(:karma, 3)
  end

  after_destroy do
    user.inc(:karma, -3)
  end

  def dislikers
    User.where(:_id.in => dislikes).limit(10)
  end

  def markers
    User.where(:_id.in => marks).limit(10)
  end

  def url
    link.present? ? link : "/post/#{token}"
  end

  protected
  def generate_domain
    if link.blank?
      res = "self.#{board.name}"
    else
      res = link[/(\.?[\p{Word}-]+\.?)+(\/|:\d+|$)/]
      res.sub!(/^www\./i, '') if res
      res.sub!(/\/$/, '') if res
    end
    self.domain = res
  end

  def calculate_score
    self.score =  YavaUtils.hot_value( marks.size - dislikes.size, created_at)
  end
end


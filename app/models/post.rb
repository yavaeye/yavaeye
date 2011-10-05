class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paginate
  include Mongoid::Paranoia
  include Mongoid::Token

  field :title
  field :link
  field :content
  field :segments, type: Array, default: []

  token :length => 5, :contains => :alphanumeric

  belongs_to :user
  belongs_to :board
  has_many :comments

  validates_presence_of :title, :board, :user
  validates_length_of :title, maximum: 128
  validates_length_of :content, maximum: 10240

  validate do
    unless link.blank? ^ content.blank?
      errors.add :base, 'link or content with some problems'
    end
    if link and (link =~ URI::regexp).nil?
      errors.add :link, 'link is invalid'
    end
  end

  after_create do
    user.karma += 3
    user.save
  end

  after_destroy do
    user.karma -= 3
    user.save
  end

  def website
    return unless link
    res = link[/(\.?[\p{Word}-]+\.?)+(\/|:\d+|$)/]
    res.sub!(/^www\./i, '') if res
    res.sub!(/\/$/, '') if res
    res
  end
end


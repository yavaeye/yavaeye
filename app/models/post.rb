class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Token
  extend Paginate

  field :title
  field :link
  field :content
  field :domain
  field :score, type: Float, default: 0.0

  token :length => 5, :contains => :alphanumeric

  belongs_to :author, class_name: 'User'
  has_many :comments
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :likers,  inverse_of: :liked_posts, class_name: 'User'
  has_and_belongs_to_many :markers,  inverse_of: :marked_posts, class_name: 'User'

  validates_presence_of :title, :author
  validates_length_of :title, maximum: 128
  validates_length_of :content, maximum: 10240
  validates_format_of :link, with: /\A#{URI::regexp}\Z/, if: ->{ link.present? }

  validate do
    if link.blank? and content.blank?
      errors.add :base, 'link or content has some problems'
    end
  end

  before_save :generate_domain, :calculate_score
  after_create :increase_authors_karma
  after_destroy :decrease_authors_karma

  def url
    link.present? ? link : "/post/#{token}"
  end

  protected
  def generate_domain
    if link.blank?
      res = "yavaeye.com"
    else
      res = link[/(\.?[\p{Word}-]+\.?)+(\/|:\d+|$)/]
      res.sub!(/^www\./i, '') if res
      res.sub!(/\/$/, '') if res
    end
    self.domain = res
  end

  def calculate_score
    self.score = Ranking.hot_value(markers.size, created_at)
  end

  def increase_authors_karma
    author.inc(:karma, 3)
  end

  def decrease_authors_karma
    author.inc(:karma, -3)
  end
end

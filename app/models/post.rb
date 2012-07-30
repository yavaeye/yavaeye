class Post < ActiveRecord::Base
  include Hstore
  extend Paginate
  
  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :likers, join_table: "users_liked_posts"

  validates_presence_of :title, :author
  validates_length_of :title, maximum: 128
  validates_length_of :content, maximum: 10240
  validates_format_of :link, with: /\A#{URI::regexp}\Z/, if: ->{ link.present? }

  validate do
    unless link.blank? ^ content.blank?
      errors.add :base, 'link or content has some problems'
    end
  end

  before_save :generate_domain, :calculate_score
  after_create :increase_authors_karma
  after_destroy :decrease_authors_karma

  def url
    link.present? ? link : "/post/#{id}"
  end

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
    user.karma += 3
    user.save!
  end

  def decrease_authors_karma
    user.karma -= 3
    user.save!
  end
end

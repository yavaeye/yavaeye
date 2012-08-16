# coding: utf-8

class Post < ActiveRecord::Base
  include ActiveRecord::Hstore
  extend ActiveRecord::Paginate

  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :likers, join_table: "users_liked_posts", class_name: 'User'

  validates_presence_of :title, :user
  validates_length_of :title, maximum: 128
  validates_length_of :content, maximum: 10240
  validates_format_of :link, with: /\A#{URI::regexp}\Z/, if: ->{ link.present? }

  validate do
    unless link.blank? ^ content.blank?
      errors.add :base, '内容出错'
    end
  end

  before_save :generate_domain, :calculate_score
  after_create do
    user.inc_karma! 3
  end
  after_destroy do
    user.inc_karma! -3
  end

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
    self.score = Ranking.hot_value(marker_count, created_at)
  end
end

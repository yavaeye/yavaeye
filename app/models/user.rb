class User < ActiveRecord::Base
  has_one :profile

  has_many :mentions
  has_many :posts
  has_many :comments
  has_and_belongs_to_many :liked_posts, join_table: "users_liked_posts"

  validates_uniqueness_of :name
  validates_presence_of :name, :gravatar_id
  validates_length_of :name, minimum: 2, maximum: 32
  validates_format_of :name, with: /\A[\p{Word}-]+\z/u
  validates_format_of :email, with: /\A.+@.+\z/u
  validates_length_of :intro, maximum: 1024

  def read_mentions
    mentions.unread.update_all read: true
  end

  def mark post
    
  end
  
  def read post
    :marked_post_ids
    read_post_ids
  end
  
  def like post
    posts << post
  end
end

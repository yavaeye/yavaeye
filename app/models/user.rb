class User < ActiveRecord::Base
  belongs_to :profile
  has_many :mentions
  has_many :posts
  has_many :comments
  has_and_belongs_to_many :liked_posts, join_table: "users_liked_posts", class_name: "Post"

  validates_uniqueness_of :name
  validates_presence_of :name, :gravatar_id
  validates_length_of :name, minimum: 2, maximum: 32
  validates_format_of :name, with: /\A[\p{Word}-]+\z/u
  validates_length_of :intro, maximum: 1024

  def read_mentions
    mentions.unread.update_all read: true
  end

  def inc_karma! n
    update_columns karma: (karma + n)
  end

  def mark post
    transaction do
      profile.hstore_update! :marked_posts, post.id => Time.now.to_i
      post.update_columns marker_count: (post.marker_count + 1)
    end
  end

  def unmark post
    transaction do
      profile.hstore_delete! :marked_posts, post.id
      post.update_columns marker_count: (post.marker_count - 1)
    end
  end

  def read post
    transaction do
      profile.hstore_update! :read_posts, post.id => Time.now.to_i
      post.update_columns reader_count: (post.reader_count + 1)
    end
  end

  def unread post
    transaction do
      profile.hstore_delete! :read_posts, post.id
      post.update_columns reader_count: (post.reader_count - 1)
    end
  end

  def like post
    transaction do
      liked_posts << post
      post.update_columns liker_count: (post.liker_count + 1)
    end
  end

  def unlike post
    transaction do
      liked_posts.delete post
      post.update_columns liker_count: (post.liker_count - 1)
    end
  end

  def to_href
    "/users/#{id}"
  end

  # TODO digest profile for updating

  def profile_hash min_tag_size
    subscribed_tags = Profile.where(id: profile_id).pluck('subscribed_tags').first
    subscribed_tags.sort_by {|k, v| -v.to_i }.map &:first

    if subscribed_tags.size < min_tag_size
      subscribed_tags += Tag.limit(n - subscribed_tags.size).pluck(:name)
    end

    {
      subscribed_tags: subscribed_tags,
      liked_posts: Hash[liked_posts.map{|p| [p.id, p.updated_at]}],
      marked_posts: profile.marked_posts,
      read_posts: profile.read_posts
    }
  end

  def self.default_profile_hash min_tag_size
    {
      subscribed_tags: ::Tag.limit(min_tag_size).pluck(:name),
      liked_posts: {},
      marked_posts: {},
      read_posts: {}
    }
  end
end

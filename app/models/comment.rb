class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates_presence_of :content, :user, :post
  validates_length_of :content, maximum: 10240

  after_create :increase_post_author_karma, :mention_post_author
  after_destroy :decrease_post_author_karma

  def mention_post_author
    post.user.mentions.create! \
      type: 'post',
      mentioner: user.name,
      mentioner_href: user.to_href,
      content: content, # TODO cut text
      content_href: to_href
  end

  def increase_post_author_karma
    post.user.inc_karma! 0.5 if user != post.user
  end

  def decrease_post_author_karma
    post.user.inc_karma! -0.5 if user != post.user
  end

  def to_href
    "/posts/#{post_id}#comment_#{id}"
  end
end

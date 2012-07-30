class Comment < ActiveRecord::Base
  belongs_to :post

  validates_presence_of :content, :author, :post
  validates_length_of :content, maximum: 10240

  after_create :increase_post_author_karma, :mention_post_author
  after_destroy :decrease_post_author_karma

  def mention_post_author
    post.author.mentions.create(type: 'post', triggers: [author.name],
                                event: post._id, text: content)
  end

  def increase_post_author_karma
    post.author.inc(:karma, 0.5) if author != post.author
  end

  def decrease_post_author_karma
    post.author.inc(:karma, -0.5) if author != post.author
  end
end

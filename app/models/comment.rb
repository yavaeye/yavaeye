class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :content

  belongs_to :post
  belongs_to :author, class_name: 'User'

  validates_presence_of :content, :author, :post
  validates_length_of :content, maximum: 10240

  after_create :increase_post_author_karma, :mention_post_author
  after_destroy :decrease_post_author_karma

  protected
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

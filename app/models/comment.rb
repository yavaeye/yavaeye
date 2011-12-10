class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :content

  belongs_to :user
  belongs_to :post

  validates_presence_of :content, :user, :post
  validates_length_of :content, maximum: 10240

  after_create :mention_users

  after_create do
    user.inc(:karma, 1)
  end

  after_destroy do
    user.inc(:karma, -1)
  end

  protected
  def mention_users
    if user.id != post.user.id
      mention_new ["post", "reply"]
    end
  end

  private
  def mention_new types
    types.each do |type|
      if mention = Mention.where(type: type, event: post.id).first
        mention.add_to_set(:triggers, user.nick)
        mention.update_attributes(read: false)
      else
        Mention.new(type: type, triggers: [user.nick], event: post.id).deliver
      end
    end
  end
end

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :content

  belongs_to :user
  belongs_to :post

  validates_presence_of :content
  validates_length_of :content, maximum: 10240

  after_create do
    return if user.id == post.user.id
    mention "post"
    mention "reply"
  end

  private

  def mention type
    mention = Mention.where(event: post.id, type: type).first
    if mention
      (mention.triggers << user.nick).uniq!
      mention.read = false
      mention.save
    else
      Mention.new(type: type, triggers: [user.nick], event: post.id, text: "post").deliver
    end
  end
end


class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text
  field :read, type: Boolean, default: false

  belongs_to :user

  validates_presence_of :text
  validates_length_of :text, maximum: 10240
end

class ReceivedMessage < Message
  field :from

  validates_presence_of :from
  validates_length_of :from, minimum: 2, maximum: 32
end

class SentMessage < Message
  field :to
  field :read, type: Boolean, default: true

  validates_presence_of :to
  validates_length_of :to, minimum: 2, maximum: 32
end

class Mention < Message
  field :type
  field :event
  field :triggers, type: Array, default: []

  def deliver
    case type
    when 'post'
      post = Post.find(event)
      post.user.messages << self
      post.user.save
    when 'reply'
      post = Post.find(event)
      post.comments.each do |c|
        next if c.user.nick == triggers.first
        c.user.messages << self
        c.user.save
      end
    when 'unfollow'
      user = User.find(event)
      user.messages << self
      user.save
    when 'unsubscribe'
      board = Board.find(event)
      board.user.messages << self
      board.user.save
    else
    end
  end
end

class Notification < Message
  field :type
  field :event

  def deliver
    case type
    when 'founder' then
    when 'achievement' then
    else
    end
  end
end


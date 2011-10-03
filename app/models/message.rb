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
      post = Post.where(_id: event).first
      return unless post
      post.user.messages << self
      post.user.save
    when 'unfollow' then
      user = User.where(_id: event).first
      return unless user
      user.messages << self
      user.save
    when 'unsubscribe' then
      board = Board.where(_id: event).first
      return unless board
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
    when 'founder'
      text = %Q{}
    when 'achievement' then
    else
    end
  end
end


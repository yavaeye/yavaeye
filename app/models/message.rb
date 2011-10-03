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
    when 'at' then
    when 'reply'
      post = Post.where(_id: event).first
      if post
        post.user.messages << self
        post.user.save
      end
    when 'unfollow' then
    when 'unsubscribe' then
    else
    end
  end
end

class Notification < Message
  field :event
  def deliver type
    case type
    when 'founder'
      text = %Q{}
    when 'achievement' then
    else
    end
  end
end


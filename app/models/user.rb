class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :openid
  field :nick
  field :email
  field :karma, type: Integer, default: 0
  field :unsubscribes, type: Array, default: []
  field :unfollower_ids, type: Array, default: []
  field :unfollowing_ids, type: Array, default: []

  embeds_one :profile

  has_many :posts
  has_many :boards
  has_many :comments
  has_many :messages
  has_many :achievements

  validates_presence_of :openid
  validates_uniqueness_of :openid, :nick
  validates_length_of :nick, minimum: 2, maximum: 32
  validates_length_of :email, maximum: 128
  validates_format_of :nick, with: /^[\p{Word}-]+$/u

  class Profile
    include Mongoid::Document

    field :intro

    embedded_in :user

    validates_length_of :intro, maximum: 1024
  end

  def last_posts
    posts.order_by(:created_at.desc).limit(5)
  end

  def last_comments
    comments.order_by(:created_at.desc).limit(5)
  end

  def unfollowings
    User.where(:_id.in => unfollowing_ids)
  end

  def unfollowers
    User.where(:_id.in => unfollower_ids)
  end

  def follow user_id
    return if user_id == _id
    user = User.where(_id: user_id).first
    if user
      user.pull(:unfollower_ids, _id)
      pull(:unfollowing_ids, user_id)
    end
  end

  def unfollow user_id
    return if user_id == _id
    user = User.where(_id: user_id).first
    if user
      user.add_to_set(:unfollower_ids, _id)
      add_to_set(:unfollowing_ids, user_id)
      Mention.new(type: "unfollow", triggers: [nick], event: user.id, text: "unfollow u").deliver
    end
  end

  def subscribe board_name
    board = Board.find_by_name board_name
    if board
      pull(:unsubscribes, board.name)
    end
  end

  def unsubscribe board_name
    board = Board.find_by_name board_name
    if board
      add_to_set(:unsubscribes, board.name)
      Mention.new(type: "unsubscribe", triggers: [nick], event: board.id, text: "unfollow your board").deliver
    end
  end

  def mark post_id
    post = Post.where(_id: post_id).first
    if post
      post.add_to_set(:marks, _id)
    end
  end

  def dislike post_id
    post = Post.where(_id: post_id).first
    if post
      post.add_to_set(:dislikes, _id)
    end
  end

  def subscribes
    boards = Board.not_in(name: unsubscribes)
  end

  def mentions
    messages.where(_type: "Mention")
  end

  def received_messages
    messages.where(_type: "ReceivedMessage")
  end

  def sent_messages
    messages.where(_type: "SentMessage")
  end

  def deliver message
    receiver_nick = message.to
    receiver = User.where(nick: receiver_nick).first
    if(User.where(nick: receiver_nick).first)
      messages << message
      save
      receiver.messages << ReceivedMessage.new(from: nick, text: message.to)
      receiver.save
    end
  end

  def receive message
    message.update_attributes(read: true)
  end
end


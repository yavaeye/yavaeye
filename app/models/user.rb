class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :openid
  field :nick
  field :email
  field :unsubscribes, type: Hash, default: {}
  field :unfollower_ids, type: Array, default: []
  field :unfollowing_ids, type: Array, default: []

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

    field :twitter
    field :facebook
    field :googleplus

    embedded_in :user, inverse_of: :profile
  end

  def unfollowings
    User.where(:_id.in => unfollowing_ids)
  end

  def unfollowers
    User.where(:_id.in => unfollower_ids)
  end

  def follow id
    return if id == _id
    user = User.where(_id: id).first
    if user
      user.unfollower_ids.delete _id
      user.save
      unfollowing_ids.delete id
      save
    end
  end

  def unfollow id
    return if id == _id
    user = User.where(_id: id).first
    if user
      user.unfollower_ids << _id
      user.save
      unfollowing_ids << id
      save
    end
  end

  def subscribe slug
    board = Board.where(slug: slug).first
    if board
      unsubscribes.delete board.slug
      save
    end
  end

  def unsubscribe slug
    board = Board.where(slug: slug).first
    if board
      unsubscribes[board.slug] = board.name
      save
    end
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
    message.read = true
    message.save
  end
end


class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :openid
  field :nick
  field :email
  field :subscribes, type: Hash, default: {}
  field :unfollower_count, type: Integer, default: 0

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

end


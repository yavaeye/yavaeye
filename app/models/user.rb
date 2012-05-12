class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name
  field :email
  field :intro
  field :gravatar_id
  field :karma, type: Float, default: 0.0

  embeds_one :profile

  has_many :mentions
  has_many :posts, inverse_of: :author
  has_many :comments, inverse_of: :author
  has_and_belongs_to_many :liked_posts, inverse_of: :likers, class_name: 'Post'
  has_and_belongs_to_many :marked_posts, inverse_of: :markers, class_name: 'Post'


  validates_uniqueness_of :name
  validates_presence_of :name, :gravatar_id
  validates_length_of :name, minimum: 2, maximum: 32
  validates_format_of :name, with: /^[\p{Word}-]+$/u
  validates_format_of :email, with: /\A.+@.+\z/u
  validates_length_of :intro, maximum: 1024

  def read_mentions mentions
    mentions.update_all(read: true)
  end
end

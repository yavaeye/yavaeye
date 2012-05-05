class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :name
  field :email
  field :credentials, type: Hash, default: {}
  field :karma, type: Float, default: 0.0

  embeds_one :profile

  has_many :metions
  has_many :posts, inverse_of: :author
  has_many :comments, inverse_of: :author
  has_and_belongs_to_many :read_posts, inverse_of: :readers, class_name: 'Post'
  has_and_belongs_to_many :marked_posts, inverse_of: :markers, class_name: 'Post'


  validates_uniqueness_of :name
  validates_presence_of :name, :email, :credentials
  validates_length_of :name, minimum: 2, maximum: 32
  validates_format_of :name, with: /^[\p{Word}-]+$/u
  validates_format_of :email, with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/u

  class Profile
    include Mongoid::Document

    field :intro

    embedded_in :user

    validates_length_of :intro, maximum: 1024
  end
end

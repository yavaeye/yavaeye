class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :user_id
  field :user_nick
  field :content

  belongs_to :post

  validates_presence_of :content
  validates_length_of :content, maximum: 10240
end


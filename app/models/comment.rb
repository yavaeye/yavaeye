class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :content

  belongs_to :post
  belongs_to :author, class_name: 'User'

  validates_presence_of :content, :author, :post
  validates_length_of :content, maximum: 10240
end

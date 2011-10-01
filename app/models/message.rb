class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :content
  field :read, type: Boolean, default: false

  belongs_to :user

  validates_presence_of :content
  validates_length_of :content, maximum: 10240
end

class Inbox < Message
  field :from
end

class Outbox < Message
  field :to
end

class Notification < Message
  field :event
  field :triggers, type: Array, default: []
end


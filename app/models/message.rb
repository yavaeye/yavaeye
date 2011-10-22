#encoding: utf-8
class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text
  field :read, type: Boolean, default: false

  belongs_to :user

  validates_presence_of :user
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
  include Deliver
  
  field :type
  field :event
  field :triggers, type: Array, default: []
end


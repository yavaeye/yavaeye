class Mention < ActiveRecord::Base
  extend Paginate
  belongs_to :user

  scope :unread, -> { where read: false }

  def Mention.inheritance_column
    :not_used
  end
end

class Tag < ActiveRecord::Base
  # TODO rate tags
  def self.for user, n
    if user
      tags = user.ordered_subscribed_tags
      if tags.size < n
        tags + limit(n - tags.size).pluck(:name)
      else
        tags
      end
    else
      limit(n).pluck(:name)
    end
  end
end

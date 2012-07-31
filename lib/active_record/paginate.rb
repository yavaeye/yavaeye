module ActiveRecord
  module Paginate
    def paginate page, per_page=20
      page = page.to_i
      page = 1 if page < 1
      per_page = per_page.to_i
      offset = (page.to_i - 1) * per_page
      offset(offset).limit(per_page)
    end
  end
end

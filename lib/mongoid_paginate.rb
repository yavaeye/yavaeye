module Mongoid
  module Paginate
    extend ActiveSupport::Concern

    module ClassMethods

      def paginate_by_token *args
        options = args.extract_options!
        perpage = options.delete(:perpage) || 15
        column = options.delete(:order_by) || :created_at

        anchor = self.where(token: args.first).first
        criteria = self.where(column.lte => anchor[column])
        criteria.where(options).and(:token.ne => args.first).order_by(column.desc).limit(perpage)
      end
    end
  end
end


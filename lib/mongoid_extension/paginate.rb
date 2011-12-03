module Mongoid
  module Paginate
    extend ActiveSupport::Concern

    module ClassMethods

      def paginate *args
        options = args.extract_options!
        pagenum = options.delete(:pagenum) || 1
        pagenum = 1 if pagenum.to_i <= 0
        perpage = options.delete(:perpage) || 15
        column = options.delete(:order_by) || :created_at

        criteria.where(options).order_by(column.desc).skip((pagenum-1) * perpage).limit(perpage)
      end

      # work with mongoid_token
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


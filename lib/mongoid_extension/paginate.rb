module Mongoid
  module Paginate
    extend ActiveSupport::Concern

    module ClassMethods

      def paginate *args
        options = args.extract_options!
        pagenum = options.delete('pagenum') || 1
        pagenum = 1 if pagenum.to_i <= 0
        perpage = options.delete('perpage') || 15
        column = options.delete('order_by') || :created_at

        where(options).desc(column)
          .skip((pagenum-1) * perpage)
          .limit(perpage)
      end

      # work with mongoid_token
      def paginate_by_token *args
        options = args.extract_options!
        perpage = options.delete('perpage') || 15
        column = options.delete('order_by') || :created_at

        if token = options.delete('token')
          if anchor = where(token: token).first
            where(options).and(column.to_sym.lte => anchor[column])
              .and(:token.ne => token)
              .desc(column).limit(perpage)
          end
        else
          where(options).desc(column.to_sym).limit(perpage)
        end
      end
    end
  end
end


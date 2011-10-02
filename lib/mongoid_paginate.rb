module Mongoid
  module Paginate
    extend ActiveSupport::Concern

    module ClassMethods

      def paginate_by_token *args
        options = args.extract_options!
        perpage = options[:perpage] ||= 15
        column = options[:order_by] ||= :created_at
        options.delete_if {|k, v| k == :perpage || k == :order_by}

        anchor = self.where(token: args.first).first
        criteria = self.where(column.lte => anchor[column])
        criteria.where(options).order_by(column.desc).skip(1).limit(perpage)
      end
    end
  end
end

